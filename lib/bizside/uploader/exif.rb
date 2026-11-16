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

      def auto_orient(&block)
        process_image_with_convert(:auto_orient, &block)
      end

      def strip(&block)
        process_image_with_convert(:strip, &block)
      end

      # 【ImageMagick 6.9.13.58 対策】
      # ImageMagick 6.9.13.58 では、mogrify を出力先の指定なしで実行（上書き）すると
      # "no encode delegate for this image format" で失敗する。convert（入力→出力）は成功する。
      # manipulate! で得られる MiniMagick::Image のメソッド（img.auto_orient など）は
      # mogrify の上書きを使うため、そのままでは画像のアップロードが全て失敗する。
      # そのため、convert で処理する minimagick! を使う。
      # auto_orient の後に strip を実行する通常の順序では、処理結果は変わらない。
      # ただし ImageProcessing は読み込み時に向きを補正するため、strip だけを単独で実行すると、
      # 従来は向きの情報が消えるだけだったが、画像の向きも補正されるようになる。
      #
      # ブロックを渡した場合は、従来どおり、処理後の MiniMagick::Image を受け取って返すブロックとして呼ばれる。
      def process_image_with_convert(operation, &block)
        return unless self.model.valid?

        mime = MimeMagic.by_path(self.file.path)
        return unless mime and mime.image?

        minimagick!(block) { |builder| builder.public_send(operation) }
      end

    end
  end
end
