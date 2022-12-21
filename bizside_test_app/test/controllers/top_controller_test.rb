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
    assert response.body.include?('show.html.erb'), 'show.html+pc.erb は無いので show.html.erb を表示する'
  end

  def test_トップ_iphone
    get '/', params: {ua: :iphone}
    assert_response :success
    assert_template :"show"
    assert response.body.include?('show.html+iphone.erb')
  end

  def test_トップ_android
    get '/', params: {ua: :android}
    assert_response :success
    assert_template :"show"
    assert response.body.include?('show.html+sp.erb'), 'show.html+android.erb は無いので show.html+sp.erb を表示する'
  end
end
