require 'test_helper'

class Bizside::AuditLogTest < ActiveSupport::TestCase

  def test_build_loginfoメソッド_request_uriにはBIZSIDE_REQUEST_URIが優先的に設定される
    request_uri = 'https://app.example.com/path/to/action?id=000&api_key=xxxx'
    env = Rack::MockRequest.env_for(request_uri, method: 'GET')
    env['REQUEST_URI'] = request_uri.dup

    app = ->(_env){ [200, _env, 'body'] }
    middleware = Bizside::AuditLog.new(app)
    start = 1.days.before.strftime('%Y-%m-%dT%H:%M:%S.%3N%z')
    stop = 1.days.after.strftime('%Y-%m-%dT%H:%M:%S.%3N%z')

    loginfo = middleware.send(:build_loginfo, env, start, stop, 200, nil)
    assert_equal request_uri, loginfo[:request_uri]

    new_env = env.merge('BIZSIDE_REQUEST_URI' => 'https://env.example.com/path/to/action?key=999&api_key=yyyy')
    loginfo = middleware.send(:build_loginfo, new_env, start, stop, 200, nil)
    assert_equal 'https://env.example.com/path/to/action?key=999&api_key=yyyy', loginfo[:request_uri]
  end
end
