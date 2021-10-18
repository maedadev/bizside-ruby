module Bizside
  module Configurations
    module Mail

      def mail
        if @mail.nil?
          configfile = File.join('config', 'mail.yml')
        
          if File.exist?(configfile)
            @mail = Bizside::Config.new(YAML.load_file(configfile)[Bizside.env])
          else
            @mail = Bizside::Config.new
          end
        end

        @mail
      end

      def default_url_options
        {:protocol => 'https', :host => mail.app_host, :script_name => prefix}
      end

      def smtp_settings
        ret = {}
        ret[:address] = mail.smtp.host if mail.smtp.host?
        ret[:port] = mail.smtp.port if mail.smtp.port?
        ret[:enable_starttls_auto] = mail.smtp.enable_starttls_auto if mail.smtp.enable_starttls_auto?
        ret[:openssl_verify_mode] = mail.smtp.openssl_verify_mode if mail.smtp.openssl_verify_mode?
        ret[:authentication] = mail.smtp.authentication if mail.smtp.authentication?
        ret[:user_name] = mail.smtp.username if mail.smtp.username?
        ret[:password] = mail.smtp.password if mail.smtp.password?
        ret
      end

    end
  end
end
