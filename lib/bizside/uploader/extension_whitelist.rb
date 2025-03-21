module Bizside
  module Uploader
    module ExtensionWhitelist
      extend ActiveSupport::Concern

      included do
        @@extensions = Bizside.config.file_uploader.extensions_file_path.then do |filename|
          filename = File.join(__dir__, 'default_extensions.yml') unless filename.present?
          entire_config = YAML.respond_to?(:unsafe_load_file) ? YAML.unsafe_load_file(filename) : YAML.load_file(filename)
          entire_config.values
        end
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
