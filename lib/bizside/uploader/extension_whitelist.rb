module Bizside
  module Uploader
    module ExtensionWhitelist
      extend ActiveSupport::Concern

      included do
        default_extensions = Bizside.config.file_uploader.extensions_file_path.present? ? Bizside.config.file_uploader.extensions_file_path : 
          File.join(File.dirname(__FILE__), 'default_extensions.yml')
        @@extensions = YAML.load_file(default_extensions).values
      end
      
      def extension_allowlist
        return nil unless Bizside.config.file_uploader.extension_whitelist_enabled?
            
        @@extensions
      end
      
      private

      def rails_logger_available?
        defined?(Rails) && !Rails.logger.nil?
      end

    end
  end
end
