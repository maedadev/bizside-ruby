require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  def test_正当なURL_スキームあり
    valid_url = %w[
      http://example.com
      https://example.com
      http://example.com/user
      http://example.com/user?id=1
      http://example.com:8080
    ]

    valid_url.each do |url|
      url = Url.new(valid_params.merge(url: url))
      assert url.valid?
    end
  end

  def test_正当なURL_スキームなし
    valid_url = %w[
      example
      example.com
      example.com/user
      example.com/user?id=1
      ftp://example.com
    ]

    valid_url.each do |url|
      url = Url.new(valid_params.merge(url_without_schema: url))
      assert url.valid?
    end
  end

  def test_不正なURL_nil
    url = Url.new(valid_params.merge(url: nil))
    assert url.invalid?

    url = Url.new(valid_params.merge(url_without_schema: nil))
    assert url.invalid?
  end

  def test_不正なURL_スキームあり
    invalid_url = %w[
      example
      example.com
      ftp://example.com
      https://www.あいう
      http://example.com:test
      http://"[]{}<>|^%
    ]

    invalid_url.each do |url|
      url = Url.new(valid_params.merge(url: url))
      assert url.invalid?
    end
  end

  def test_不正なURL_スキームなし
    invalid_url = %w[
      http://example.com
      https://example.com
    ]

    invalid_url.each do |url|
      url = Url.new(valid_params.merge(url_without_schema: url))
      assert url.invalid?
    end
  end

  def test_空文字
    url = Url.new(valid_params.merge(url: ''))
    assert url.invalid?

    url = Url.new(valid_params.merge(url_without_schema: ''))
    assert url.valid?
  end

  def test_エラーメッセージ
    url = Url.new(valid_params.merge(url: 'https://あああ.com'))
    assert url.invalid?
    assert_equal ['Url はURLとして正しくありません。'], url.errors.full_messages

    url = Url.new(valid_params.merge(url: 'example.com'))
    assert url.invalid?
    assert_equal ['Url は http:// または https:// から始めてください。'], url.errors.full_messages

    url = Url.new(valid_params.merge(url_without_schema: 'https://example.com'))
    assert url.invalid?
    assert_equal ['Url without schema は http:// または https:// を含めないでください。'], url.errors.full_messages
  end

  def valid_params
    {
      url: 'http://example.com',
      url_without_schema: 'example.com'
    }
  end
end