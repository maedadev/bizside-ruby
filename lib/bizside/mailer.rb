module Bizside
  module Mailer

    def mail(headers={ })
      headers = headers.merge(:delivery_method_options => Bizside.config.smtp_settings)
      m = super
      m.transport_encoding = '8bit'
      m.from ||= Bizside.config.mail.from
      m
    end

    protected

    def set_priority_headers(priority)
      get_priority_headers(priority).each do |key, value|
        headers[key] = value
      end
    end

    private

    def get_priority_headers(priority)
      ret = {}

      # Outlook、ThunderBird
      ret['X-Priority'] = priority

      # Notes
      notes_priority = convert_priority_for_notes(priority)
      if notes_priority
        ret['Importance'] = notes_priority
      end

      ret
    end

    def convert_priority_for_notes(priority)
      case priority.to_i
      when 1
        return 'High'
      when 2
        return 'High'
      when 3
        return 'Normal'
      when 4
        return 'Low'
      when 5
        return 'Low'
      else
        return nil
      end
    end
    
  end

end
