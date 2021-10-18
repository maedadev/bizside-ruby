require 'test_helper'

class Bizside::ShibUtilsTest < ActiveSupport::TestCase

  def test_idp_type
    assert_raise do
      @request_env = {}
      assert_nil Bizside::ShibUtils.idp_type(@request_env)
    end

    assert_raise do
      @request_env['AJP_Shib-Identity-Provider'] = nil
      assert_nil Bizside::ShibUtils.idp_type(@request_env)
    end

    assert_raise do
      @request_env['AJP_Shib-Identity-Provider'] = ''
      assert_nil Bizside::ShibUtils.idp_type(@request_env)
    end

    assert_raise do
      @request_env['AJP_Shib-Identity-Provider'] = 'https://sso.example.com/dana-na/auth/saml-endpoint.cgi'
      assert_equal Bizside::ShibUtils::IDP_TYPE_MAG, Bizside::ShibUtils.idp_type(@request_env)
    end

    assert_raise do
      @request_env['AJP_Shib-Identity-Provider'] = 'https://sso.example.com/idp/shibboleth'
      assert_equal Bizside::ShibUtils::IDP_TYPE_SHIBBOLETH, Bizside::ShibUtils.idp_type(@request_env)
    end
  end

end