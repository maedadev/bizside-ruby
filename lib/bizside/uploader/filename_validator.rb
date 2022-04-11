module Bizside
  module Uploader
    module FilenameValidator
      extend ActiveSupport::Concern

      included do  
        before :cache, :validate_filename!
      end
      
      def invalid_filename_regexp
        CarrierWave::SanitizedFile.sanitize_regexp
      end
    
      private

      def validate_filename!(new_file)
        if new_file and new_file.respond_to?(:original_filename)
          filename = new_file.original_filename
        else 
          filename = File.basename(new_file.path)
        end

        if invalid_filename_regexp =~ filename
          message = I18n.translate(:'errors.messages.filename_error', filename: filename)
          raise CarrierWave::IntegrityError, message
        end
      end

    end
  end
end
