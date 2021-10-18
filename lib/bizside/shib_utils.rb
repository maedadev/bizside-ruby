# Shibboleth環境に関するユーティリティ
class Bizside::ShibUtils
  LOGOUT_URL = '/Shibboleth.sso/Logout'

  def self.get_bizside_user(request)
    ret = _get_bizside_user(request.env)
    ret ||= _get_bizside_user(request.headers)
    ret
  end
  
  def self._get_bizside_user(hash)
    ret = hash['mail']
    ret ||= hash['HTTP_X_BIZSIDE_USER']
    ret ||= hash['X-BIZSIDE-USER']
    ret
  end

end
