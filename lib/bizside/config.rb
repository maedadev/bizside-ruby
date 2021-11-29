require_relative 'configurations/mail'
require_relative 'configurations/prefix'
require_relative 'configurations/storage'

module Bizside
  class Config
    include Bizside::Configurations::Mail
    include Bizside::Configurations::Prefix
    include Bizside::Configurations::Storage

    def initialize(hash = {})
      @hash = hash || {}
    end

    def [](key)
      key = key.to_s
      return (@hash[key[0..-2]] ? true : false) if key.end_with?('?')

      ret = @hash[key]
      if ret.nil?
        ret = self.class.new
      elsif ret.is_a?(Hash)
        ret = self.class.new(ret)
      end

      ret
    end

    def []=(key, value)
      value = self.class.new(value) if value.is_a?(Hash)
      @hash[key.to_s] = value
    end

    def to_h
      @hash.dup
    end

    # Hash継承時代での互換維持のために実装
    def empty?
      @hash.empty?
    end

    # オブジェクトの Hash への暗黙の変換が必要なときに内部で呼ばれるメソッド
    # Hash継承時代での互換維持のために実装。
    # なお、Hashの継承時代でも @hash を活用していたので、空ハッシュを返す
    # @see https://docs.ruby-lang.org/ja/latest/method/Object/i/to_hash.html
    def to_hash
      warn "DEPRECATION WARNING: #{__method__} is deprecated and will be removed."
      {}
    end

    def method_missing(name, *args)
      ret = self[name]

      if ret.is_a?(Hash) || ret.is_a?(::Bizside::Config)
        unless args[0].nil?
          ret = self[name] = args[0]
        end
      end

      ret
    end

  end
end
