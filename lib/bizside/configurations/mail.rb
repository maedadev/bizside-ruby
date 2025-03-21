module Bizside
  module Configurations
    module Mail

      def mail
        return @mail if defined? @mail

        configfile = File.join('config', 'mail.yml')
        
        @mail = if File.exist?(configfile)
            entire_config = YAML.respond_to?(:safe_load_file) ? YAML.safe_load_file(configfile, aliases: true) : YAML.load_file(configfile)
            Bizside::Config.new(entire_config[Bizside.env])
          else
            Bizside::Config.new
          end
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
