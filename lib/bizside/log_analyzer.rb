module Bizside
  class LogAnalyzer
    attr_reader :add_on_name
    attr_reader :error_contents

    def initialize(add_on_name, files)
      @add_on_name = add_on_name
      @files = files
    end

    def analyze(output_file_name)
      @success =  system("request-log-analyzer --format rails3 --parse-strategy cautious --file #{output_file_name}.html --output HTML #{@files.join(' ')}")
    end

    def success?
      @success
    end

    def scrape_errors
      @error_content = String.new
      @error_contents = {}

      # TODO Okozeを解析できるようにする
      return if add_on_name == 'okoze'

      # TODO ログ内で重複したエラーメッセージを除外する
      return if ['amadai', 'webcam_api', 'seri', 'sushioke'].include?(add_on_name)

      @files.each do |file|
        content = File.read(file, encoding: 'utf-8')
        content = content.encode('UTF-16BE', 'UTF-8', :invalid => :replace, :undef => :replace, :replace => '?').encode('UTF-8')
        next unless content.include?('Completed 500') or content.include?('FATAL')

        # ログをプロセス単位に分割
        partition_contents = divide_into_pid(content)
        # プロセス単位に分割したログからエラーを抽出
        partition_content_errors = extract_error_log(partition_contents)
        # 抽出したエラーを出力用にまとめる
        partition_content_errors.each do |pid, pc|
          @error_contents[pid] = "#{file}のエラー抽出結果\n\n\n" if @error_contents[pid].nil? or @error_contents[pid].empty?
          @error_contents[pid] << pc
        end

        @error_contents
      end
    end

    def divide_into_pid(content)
      pid = nil
      ret = {}
      content.each_line do |c|
        s = c.scan(/#[0-9]+\]/)
        pid = s.first.scan(/[0-9]+/).first unless s.empty?
        ret[pid] = "" unless ret[pid]
        ret[pid] << c
      end

      ret
    end

    def extract_error_log(partition_contents)
      ret = {}
      partition_contents.each do |pid, pc|
        tmp = ""
        pc.each_line do |line|
          unless line.scan(/: Started /).empty?
            if !tmp.scan(/Completed 500/).empty? or !tmp.scan(/\] FATAL/).empty? or !tmp.scan(/\[FATAL\]/).empty?
              ret[pid] = "" if ret[pid].nil? or ret[pid].empty?
              ret[pid] << tmp
            end
            tmp.clear
          end
          tmp << exclude_error_log_line(line)
        end

        # Startedの前にログが終了した場合、その時点までにエラーが含まれていれば抽出に含める
        if !tmp.empty? and !tmp.scan(/Completed 500/).empty? or !tmp.scan(/\] FATAL/).empty? or !tmp.scan(/\[FATAL\]/).empty?
          ret[pid] = "" if ret[pid].nil? or ret[pid].empty?
          ret[pid] << tmp
        end
        tmp.clear
      end

      ret
    end

    def exclude_error_log_line(line)
      ret = nil
      ret = line.match("INFO -- : ジョブ.*登録します。")

      if ret.nil?
        line
      else
        ""
      end
    end

    # TODO 重複したエラーログを除外する
    def get_duplicate_check_line(line)
      ret = line.scan(/(INFO -- :.*|ERROR -- :.*|WARN -- :.*|FATAL -- :.*)/).first
      ret = ret.gsub(/\" for .*/, "\"") unless ret.nil or ret.empty?

      ret
    end

    # TODO 重複したエラーログを除外する
    def duplicate_error_log?(extract_error_logs, duplicate_check_lines)
      res = false
      extract_error_logs.each do |eer|
        tmp = false
        duplicate_check_lines.each do |dcl|
          tmp = eer.include?(dcl)
          break unless tmp
        end
        res = tmp
        break if res
      end

      res
    end
  end
end
