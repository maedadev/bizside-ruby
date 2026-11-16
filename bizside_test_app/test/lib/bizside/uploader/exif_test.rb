require 'test_helper'
require 'base64'
require 'tmpdir'

# Bizside::Uploader::Exif（画像の向きの補正・メタ情報の除去）のテスト
class Bizside::UploaderExifTest < ActiveSupport::TestCase

  WIDTH = 40
  HEIGHT = 20
  ORIENTATION_RIGHT_TOP = 6 # EXIF の向き。90度回転（時計回り）で正しい向きになる

  # 横長（WIDTH x HEIGHT）の小さな画像。ImageMagick のバージョン（MiniMagick の API）に依存せず用意できるよう、base64 で持つ。
  #   convert -size 40x20 gradient:red-blue -strip -quality 70 base.jpg
  #   convert -size 40x20 gradient:red-blue -strip -colors 16 -depth 4 base.png
  BASE64_IMAGES = {
    'jpg' => '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAoHBwgHBgoICAgLCgoLDhgQDg0NDh0VFhEYIx8lJCIfIiEmKzcvJik0KSEiMEExNDk7Pj4+JS5ESUM8SDc9Pjv/2wBDAQoLCw4NDhwQEBw7KCIoOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozv/wAARCAAUACgDASIAAhEBAxEB/8QAFwABAQEBAAAAAAAAAAAAAAAAAAUEBv/EABkQAQACAwAAAAAAAAAAAAAAAAATYQESUf/EABcBAQEBAQAAAAAAAAAAAAAAAAAHBQb/xAAaEQABBQEAAAAAAAAAAAAAAAAAARIVUWEC/9oADAMBAAIRAxEAPwDj5rJrT5rJrakDh281pQmsmtPmsmsgcE1pQmsT5rCBwTWmHbPTbPQU1vNE8ctjbPTbPQG80HLY2z0AbzQctn//2Q==',
    'png' => 'iVBORw0KGgoAAAANSUhEUgAAACgAAAAUBAMAAAANaGKIAAAAG1BMVEXuAADMACKqAESIAGZmAIhEAKozALsiAMwAAO4coWPdAAAAO0lEQVQY02NgoAwIYgHYBZWwABIEjbEA7IIuWAB2wVAsgATBNCyAoRwLYOgo7+gAYRAFITqAglgAVkEAcy1h9EUhggEAAAAASUVORK5CYII='
  }.freeze

  def setup
    @workdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry(@workdir) if @workdir && File.exist?(@workdir)
  end

  def test_upload_jpg_and_png
    %w(jpg png).each do |extension|
      uploader = upload(create_image("plain.#{extension}"))

      assert uploader.file.exists?, "#{extension} をアップロードできること"
      assert_equal [WIDTH, HEIGHT], dimensions(uploader.file.path), "#{extension} の大きさが変わらないこと"
    end
  end

  def test_auto_orient
    path = create_image('rotated.jpg', orientation: ORIENTATION_RIGHT_TOP)
    assert_equal 'RightTop', MiniMagick::Image.open(path)['%[orientation]'], '元の画像の向きが RightTop であること'

    uploader = upload(path)

    assert_equal [HEIGHT, WIDTH], dimensions(uploader.file.path), '向きの補正により、横長から縦長になること'
  end

  def test_strip
    path = create_image('rotated.jpg', orientation: ORIENTATION_RIGHT_TOP)
    assert_not_empty MiniMagick::Image.open(path).exif, '元の画像には EXIF があること'

    uploader = upload(path)

    assert_empty MiniMagick::Image.open(uploader.file.path).exif, 'EXIF が除去されていること'
  end

  # ImageMagick 6.9.13.58 では、mogrify を出力先の指定なしで実行（上書き）すると失敗する。
  # 環境の ImageMagick の版に左右されないよう、mogrify を使わないこと自体を確認する。
  def test_does_not_use_mogrify
    executed_commands = capture_minimagick_commands do
      upload(create_image('plain.jpg'))
      upload(create_image('plain.png'))
      upload(create_image('rotated.jpg', orientation: ORIENTATION_RIGHT_TOP))
    end

    assert_match(/\bconvert\b|\bmagick\b/, executed_commands, 'convert（または magick）で処理していること（ログが取れていること）')
    assert_no_match(/\bmogrify\b/, executed_commands, 'mogrify を使わないこと（ImageMagick 6.9.13.58 で失敗する）')
  end

  def test_does_not_process_non_image
    uploader = nil
    executed_commands = capture_minimagick_commands do
      uploader = upload(File.join(Rails.root, 'test', 'data', 'man.pdf'))
    end

    assert uploader.file.exists?, '画像以外もアップロードできること'
    assert_empty executed_commands, '画像以外は画像処理を行わないこと'
  end

  # auto_orient を継承先で上書きしてブロックを渡している場合も、従来どおり、処理後の MiniMagick::Image が渡されること
  def test_block_is_called_with_minimagick_image
    uploader_class = Class.new(AttachmentFileUploader) do
      attr_reader :yielded

      def auto_orient
        super do |img|
          @yielded = img
          img
        end
      end
    end

    uploader = upload(create_image('rotated.jpg', orientation: ORIENTATION_RIGHT_TOP), uploader_class)

    assert_kind_of MiniMagick::Image, uploader.yielded
    assert_equal [HEIGHT, WIDTH], dimensions(uploader.file.path), 'ブロックを渡しても向きが補正されること'
  end

  private

  def upload(path, uploader_class = AttachmentFileUploader)
    uploader = uploader_class.new(AttachmentFile.new)
    # アップロードの保存先（既定では /data 配下）を、テスト用の一時ディレクトリに切り替える。
    # 他のテストに影響しないよう、クラスではなくインスタンスに設定する。
    uploader.root = @workdir
    uploader.cache!(File.open(path))
    uploader
  end

  # 横長（WIDTH x HEIGHT）の画像を作成する。orientation を指定すると、EXIF の向きを設定する（jpg のみ）。
  def create_image(filename, orientation: nil)
    path = File.join(@workdir, filename)
    File.binwrite(path, Base64.decode64(BASE64_IMAGES.fetch(File.extname(filename).delete('.'))))
    embed_exif_orientation(path, orientation) if orientation
    path
  end

  # JPEG の SOI（先頭2バイト）の直後に、EXIF の向き（Orientation）だけを持つ APP1 セグメントを挿入する。
  # ImageMagick のバージョンによって、-orient などでは EXIF の向きを書き込めないため、直接埋め込む。
  def embed_exif_orientation(path, orientation)
    tiff = "MM\x00\x2A\x00\x00\x00\x08".b +                                  # ビッグエンディアン / IFD0 のオフセットは 8
           "\x00\x01".b +                                                     # エントリ数 1
           "\x01\x12\x00\x03\x00\x00\x00\x01".b + [orientation, 0].pack('nn') + # タグ 0x0112 / SHORT / 個数 1 / 値
           "\x00\x00\x00\x00".b                                               # 次の IFD なし
    payload = "Exif\x00\x00".b + tiff
    app1 = "\xFF\xE1".b + [payload.bytesize + 2].pack('n') + payload

    bytes = File.binread(path)
    File.binwrite(path, bytes.byteslice(0, 2) + app1 + bytes.byteslice(2..-1))
  end

  def dimensions(path)
    image = MiniMagick::Image.open(path)
    [image.width, image.height]
  end

  # ブロック内で MiniMagick が実行したコマンドを、ログから集めて返す
  def capture_minimagick_commands
    io = StringIO.new
    original_logger = MiniMagick.logger
    MiniMagick.logger = Logger.new(io, level: Logger::DEBUG)
    yield
    io.string
  ensure
    MiniMagick.logger = original_logger
  end

end
