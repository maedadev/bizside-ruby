require 'mimemagic'

module Bizside
  module Uploader
    module ContentTypeValidator
      extend ActiveSupport::Concern
      
      included do
        begin
          require 'carrierwave-magic'
          include CarrierWave::Magic
          process :set_magic_content_type => true
        rescue
          raise '[Bizside.gem ERROR] you need to add carrierwave-magic.gem.'
        end
        before :cache, :validate_content_type!
      end

      def content_type_checklist
        %w(jpg jpeg gif png)
      end

      private

      def validate_content_type!(new_file)
        return if new_file.path.nil?
        extension = new_file.extension.to_s

        if content_type_checklist.include?(extension.downcase)
          by_path = MimeMagic.by_extension(extension).to_s
          unless new_file.content_type == by_path
            raise CarrierWave::IntegrityError, I18n.translate(:"errors.messages.content_type_whitelist_error", content_type: new_file.content_type)
          end
        end
      end

    end
  end
end
