require 'test_helper'

class AttachmentFileTest < ActiveSupport::TestCase

  def test_long_file
    original_filename = 'あいうえおかきくけこ' * 10 + '.xls'

    file = Rack::Test::UploadedFile.new(
      Tempfile.new,
      MimeMagic.by_path(original_filename),
      original_filename: original_filename
    )

    assert_not Bizside.config.storage.ignore_long_filename_error?
    assert_raise Errno::ENAMETOOLONG do
      af = AttachmentFile.new(file: file)
    end

    Bizside.config.storage['ignore_long_filename_error'] = true
    assert Bizside.config.storage.ignore_long_filename_error?
    af = AttachmentFile.new(file: file)
    assert af.invalid?
    assert af.errors[:original_filename].any?, 'original_filename で入力エラーが発生していること'
  end

end
