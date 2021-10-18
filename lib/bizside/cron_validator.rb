module Bizside
  class CronValidator
    MIN_MINUTE  = 0
    MAX_MINUTE  = 59
    MIN_HOUR    = 0
    MAX_HOUR    = 23
    MIN_DAY     = 1
    MAX_DAY     = 31
    MIN_MONTH   = 1
    MAX_MONTH   = 12
    MIN_WEEKDAY = 0
    MAX_WEEKDAY = 7
    CRON_ATTR   = %w(minute hour day month weekday)

    def initialize(cron)
      @minute, @hour, @day, @month, @weekday = cron.split
    end

    def valid?
      valid_minute? &&
      valid_hour? &&
      valid_day? &&
      valid_month? &&
      valid_weekday?
    end

    CRON_ATTR.each do |attr|
      class_eval <<-EOS
        private

        def valid_#{attr}?
          valid_format?(@#{attr}) &&
          valid_range?(MIN_#{attr.upcase}, MAX_#{attr.upcase}, @#{attr})
        end
      EOS
    end

    private

    def valid_format?(value)
      value =~ /\A(\*(\/\d+)?|\d+(,\d+)*(-\d+)*(\/\d+)*)\Z/
    end

    def valid_range?(min, max, value)
      validate_values = remove_to_ignore_value(value).split(",")
      validate_values.reject do |v|
        if v.include?("-")
          range_v = v.split("-")
          (min..max).include?(range_v[0].to_i) &&
          (min..max).include?(range_v[1].to_i) &&
          range_v[0].to_i < range_v[1].to_i
        else
          (min..max).include? v.to_i
        end
      end.empty?
    end

    def remove_to_ignore_value(value)
      value.gsub(/(\/\d*|\*)/, "")
    end
  end
end
