require 'test_helper'

class TopControllerTest < ActionDispatch::IntegrationTest
  def test_トップ
    get '/'
    assert_response :success
    assert_template :"show"
  end

  def test_トップ_pc
    get '/', params: {ua: :pc}
    assert_response :success
    assert_template :"show"
  end

  def test_トップ_iphone
    get '/', params: {ua: :iphone}
    assert_response :success
    assert_template :"show.iphone"
  end
end
