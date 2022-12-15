require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase

  def test_正当な郵便番号
    assert ZipCode.new(zip1: '123', zip2: '4567').valid?
    assert ZipCode.new(zip1: '１２３', zip2: '４５６７').valid?
    assert ZipCode.new(zip1: nil, zip2: nil).valid?
  end

  def test_不正な郵便番号
    assert ZipCode.new(zip1: '000', zip2: nil).invalid?
    assert ZipCode.new(zip1: nil, zip2: '0000').invalid?
    assert ZipCode.new(zip1: '一二三', zip2: '四五六七').invalid?
  end

  def test_エラーメッセージ
    zip_code = ZipCode.new(zip1: 'xxx', zip2: 'yyy')
    assert zip_code.invalid?
    assert_equal ['Zip1 は郵便番号として正しくありません。'], zip_code.errors.full_messages
  end

end
