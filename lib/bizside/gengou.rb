require 'yaml'

module Bizside
  class Gengou
    @@_gengou = File.join(__dir__, 'gengou.yml').then do |filename|
      YAML.respond_to?(:safe_load_file) ? YAML.safe_load_file(filename, permitted_classes: [Date]) : YAML.load_file(filename)
    end

    def self.to_seireki(gengou, year_jp)
      # 引数 year_jpには年度の値が入る
      target_gengou = nil
      @@_gengou.invert.keys.each do |start_gengou|
        if start_gengou == gengou.to_s
          target_gengou = start_gengou
          break
        end
      end

      return nil unless target_gengou

      start_year = @@_gengou.invert[target_gengou].to_s
      return (start_year.to_i + year_jp.to_i - 1).to_s
    end

    def self.to_wareki(date)
      return if date.to_s.empty?

      match = /^(\d{4})(\d{2})?(\d{2})?$/.match(date.to_s)
      match ||= /^(\d{4})(?:[-\/](\d{1,2}))?(?:[-\/](\d{1,2}))?$/.match(date.to_s)
      match ||= /^(\d{4})年(?:(\d{1,2})月)?(?:(\d{1,2})日)?$/.match(date.to_s)
      if match
        year, month, day = match.to_a[1..3].map { |m| m&.to_i }
        return unless Date.valid_date?(year, month || 1, day || 1)
        date = Date.new(year, month || 1, day || 1)
        date = date.end_of_month if day.nil?
        date = date.end_of_year if month.nil?

        start_date, gengou = @@_gengou.sort { |a, b| b[0] <=> a[0] }.detect { |k, _| k <= date }

        return if start_date.nil?

        year = date.year - start_date.year
        "#{gengou}#{(year.zero? ? "元" : year + 1)}"
      end
    end

  end
end
