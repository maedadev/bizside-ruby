require 'mimemagic'

module Bizside
  module Uploader
    module Exif
      extend ActiveSupport::Concern

      included do
        process :auto_orient
        process :strip
      end

      private

      def auto_orient
        return unless self.model.valid?

        mime = MimeMagic.by_path(self.file.path)
        return unless mime and mime.image?

        manipulate! do |img|
          img.auto_orient
          img = yield(img) if block_given?
          img
        end
      end

      def strip
        return unless self.model.valid?

        mime = MimeMagic.by_path(self.file.path)
        return unless mime and mime.image?

        manipulate! do |img|
          img.strip
          img = yield(img) if block_given?
          img
        end
      end

    end
  end
end
