require 'test_helper'

class TelNumberTest < ActiveSupport::TestCase

  def test_正当な電話番号
    assert TelNumber.new(tel: '0120-1234-5678').valid?
    assert TelNumber.new(tel: '012012345678').valid?
    assert TelNumber.new(tel: '０１２０－１２３４－５６７８').valid?
    assert TelNumber.new(tel: '０１２０１２３４５６７８').valid?
    assert TelNumber.new(tel: nil).valid?
  end

  def test_不正な郵便番号
    assert TelNumber.new(tel: '(0120) 1234-5678').invalid?
    assert TelNumber.new(tel: '〇一二〇-一二三四-五六七八').invalid?
  end

  def test_エラーメッセージ
    tel_number = TelNumber.new(tel: 'xxx')
    assert tel_number.invalid?
    assert_equal ['Tel は正しくありません。'], tel_number.errors.full_messages
  end

end
