require 'test_helper'

class Bizside::AuditLogTest < ActiveSupport::TestCase

  def setup
    @_truncate_length_default = Bizside::AuditLog.truncate_length
  end

  def teardown
    Bizside::AuditLog.truncate_length = @_truncate_length_default
  end

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

  def test_detect_exception_backtrace_truncate_length
    al = Bizside::AuditLog.new(nil)
    clazz = Struct.new(:backtrace)
    ex = clazz.new(['a' * 8190, 'b', 'c']) # デフォルト上限の 8192 文字分の配列

    expected = 'a' * 8190 + "\nb"
    assert_equal expected, al.__send__(:detect_exception_backtrace, ex), '改行文字で結合する分が切り落とされていること'
    expected = 'a' * 8190 + "\nb\nc"
    assert_equal expected, al.__send__(:detect_exception_backtrace, ex, truncate_length: 8194), '改行文字分も考慮して指定すると切り落とされないこと'

    Bizside::AuditLog.truncate_length = 1

    expected = 'a'
    assert_equal expected, al.__send__(:detect_exception_backtrace, ex), 'Bizside::AuditLog全体として指定した truncate_length に準じていること'
    expected = 'aaaa'
    assert_equal expected, al.__send__(:detect_exception_backtrace, ex, truncate_length: 4), 'Bizside::AuditLog全体として指定した truncate_length より引数を優先すること'
  end

  def test_detect_exception_message_truncate_length
    al = Bizside::AuditLog.new(nil)
    ex = RuntimeError.new('a' * 8194) # デフォルト上限の 8192 + 2文字分

    assert_equal ('a' * 8192), al.__send__(:detect_exception_message, ex), '上限値以上が切り落とされていること'

    Bizside::AuditLog.truncate_length = 1

    assert_equal 'a', al.__send__(:detect_exception_message, ex), 'Bizside::AuditLog全体として指定した truncate_length に準じていること'
    assert_equal 'aaaa', al.__send__(:detect_exception_message, ex, truncate_length: 4), 'Bizside::AuditLog全体として指定した truncate_length より引数を優先すること'
  end

  def test_to_client_ip
    al = Bizside::AuditLog.new(nil)
    assert_nil al.__send__(:to_client_ip, nil)
    assert_nil al.__send__(:to_client_ip, '')
    assert_equal '192.168.0.1', al.__send__(:to_client_ip, '192.168.0.1')
    assert_equal '192.168.0.1', al.__send__(:to_client_ip, '192.168.0.1,')
    assert_equal '192.168.0.1', al.__send__(:to_client_ip, '192.168.0.1, 172.0.0.1')
    assert_equal '192.168.0.1', al.__send__(:to_client_ip, '192.168.0.1, 172.0.0.1, ')
  end

end
