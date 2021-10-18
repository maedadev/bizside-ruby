module Bizside
  module Resque
  end
end

require 'resque'
require 'resque/worker'
require 'resque/failure/base'
require 'resque/failure/multiple'
require 'resque/failure/redis'
require_relative 'audit/job_logger'

{
  yaml: ['config/resque.yml', 'config/redis.yml'],
  json: ['config/resque.json', 'config/redis.json']
}.each do |format, file_candidates|
  file_candidates.each do |file|
    resque_file = File.join(File.expand_path(ENV['RAILS_ROOT'] || '.'), file)
    next unless File.exist?(resque_file)

    resque_config = ERB.new(File.read(resque_file), 0, '-').result
  
    case format
    when :yaml
      Resque.redis = YAML.load(resque_config)[Bizside.env]
      break
    when :json
      Resque.redis = ActiveSupport::JSON.decode(resque_config)[Bizside.env]
      break
    else
      raise "不正なResque設定ファイルです。#{file}"
    end
  end
end

Resque.redis.namespace = "resque:#{Bizside.config.add_on_name}:#{Bizside.env}"

if defined?(Resque::Scheduler)
  Resque::Scheduler.dynamic = true
end

# tmp/stop.txt が存在する場合は一時停止する
module Resque
  class Worker

    alias_method :reserve_without_stop_txt, :reserve

    def reserve
      stop_file_path = File.join('tmp', 'stop.txt')
      if File.exist?(stop_file_path)
       puts "#{Resque.redis.namespace} #{stop_file_path} が存在するため一時停止します。"
       nil
      else
        reserve_without_stop_txt
      end
    end

  end
end

# resque-webのエラーメッセージ文字化けに対するパッチ
module Resque
  module Failure
    class Redis

      def save
        data = {
          :failed_at => UTF8Util.clean(Time.now.strftime("%Y/%m/%d %H:%M:%S %Z")),
          :payload   => payload,
          :exception => exception.class.to_s,
          :error     => exception.to_s, #UTF8Util.clean(exception.to_s), UTF8Util.cleanを呼ぶと文字化けする
          :backtrace => filter_backtrace(Array(exception.backtrace)),
          :worker    => worker.to_s,
          :queue     => queue
        }
        data = Resque.encode(data)
        Resque.redis.rpush(:failed, data)
      end

    end
  end
end

# エラーをログに出力
module Resque
  module Failure
    class LogOutput < Base
      def save
        Bizside.logger.error [
          "[FATAL] Resque #{queue}:#{worker}",
          "#{payload}",
          "#{exception.class} #{exception.to_s}",
          "#{Array(exception.backtrace).join("\n")}"
        ].join("\n")
      end
    end
  end
end

# エラーをLTSV形式で専用ログに出力
module Resque
  module Failure
    class JobAuditLog < Base

      def save
        info = build_loginfo
        return info if Bizside.rails_env&.test?
  
        logger.record(info)
  
        info
      end

      private

      def logger
        @logger ||= Bizside::Audit::JobLogger.logger
      end

      def build_loginfo
        info = {
          time: Time.now.strftime('%Y-%m-%dT%H:%M:%S.%3N%z'),
          add_on_name: Bizside.config.add_on_name,
          class: payload['class'],
          args: payload['args'].to_s,
          queue: queue,
          worker: worker.to_s,
          exception: exception.class,
          exception_message: exception.to_s,
          exception_backtrace: Array(exception.backtrace)[0..10].join("\n") # Get only the top 10 because there are many traces.
        }
        info
      end

    end
  end
end

Resque::Failure::Multiple.configure do |multi|
  multi.classes = [Resque::Failure::Redis, Resque::Failure::LogOutput, Resque::Failure::JobAuditLog]
end
