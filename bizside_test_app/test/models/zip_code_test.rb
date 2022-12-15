require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase

  def test_エラーメッセージ
    zip_code = ZipCode.new(zip1: 'xxx', zip2: 'yyy')
    assert zip_code.invalid?
    assert_equal ['Zip1 は郵便番号として正しくありません。'], zip_code.errors.full_messages
  end

end
