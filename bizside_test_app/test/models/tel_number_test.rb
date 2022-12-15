require 'test_helper'

class TelNumberTest < ActiveSupport::TestCase

  def test_エラーメッセージ
    tel_number = TelNumber.new(tel: 'xxx')
    assert tel_number.invalid?
    assert_equal ['Tel は正しくありません。'], tel_number.errors.full_messages
  end

end
