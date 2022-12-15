require 'test_helper'

class AttachmentFileTest < ActiveSupport::TestCase

  # Rack::Test::UploadedFile.new に与える StringIO クラス.
  # 通常の StringIO インスタンスを与えると path メソッドの呼び出しでエラーとなるため(bug?)、path メソッドをサポートする
  class UploadedFileStringIO < StringIO
    delegate :path, to: :@tempfile
    def initialize()
      super('tempfile body')
      @tempfile = Tempfile.new
    end
  end

  def test_long_file
    original_filename = 'あいうえおかきくけこ' * 10 + '.xls'

    file = Rack::Test::UploadedFile.new(
      # rack-test v2.x 以降では StringIO でなければ original_filename は使われないためここで呼び分ける
      # 常に UploadedFileStringIO.new でも問題はないが。
      Rack::Test::VERSION.split('.')[0] >= '2' ? UploadedFileStringIO.new : Tempfile.new,
      MimeMagic.by_path(original_filename),
      original_filename: original_filename
    )

    assert_not Bizside.config.file_uploader.ignore_long_filename_error?
    assert_raise Errno::ENAMETOOLONG do
      AttachmentFile.new(file: file)
    end

    Bizside.config['file_uploader'] = {'ignore_long_filename_error' => true}
    assert Bizside.config.file_uploader.ignore_long_filename_error?
    af = AttachmentFile.new(file: file)
    assert af.invalid?
    assert af.errors.include?(:original_filename), 'original_filename で入力エラーが発生していること'
  end

end
