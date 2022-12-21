require 'test_helper'

class TopControllerTest < ActionDispatch::IntegrationTest
  def test_トップ
    get '/'
    assert_response :success
    assert_template :"show"
    assert response.body.include?('show.html.erb')
  end

  def test_トップ_pc
    get '/', params: {ua: :pc}
    assert_response :success
    assert_template :"show"
    assert response.body.include?('show.html.erb'), 'show.pc.html.erb は無いので show.html.erb を表示する'
  end

  def test_トップ_iphone
    get '/', params: {ua: :iphone}
    assert_response :success
    assert_template :"show.iphone"
    assert response.body.include?('show.iphone.html.erb')
  end

  def test_トップ_android
    get '/', params: {ua: :android}
    assert_response :success
    assert_template :"show.sp"
    assert response.body.include?('show.sp.html.erb'), 'show.android.html.erb は無いので show.sp.html.erb を表示する'
  end
end
