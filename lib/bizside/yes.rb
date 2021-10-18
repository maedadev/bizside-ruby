module Bizside
  class Yes

    def self.confirmed?(yes_value)
      case yes_value.to_s.downcase
      when 't', 'true', 'y', 'yes'
        true
      when 'f', 'false', 'n', 'no'
        false
      else
        nil
      end
    end

  end
end
