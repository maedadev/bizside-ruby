require 'singleton'
require 'yaml'

module Bizside
  # hanaita_conf をテストするため、 singleton 以前のクラスを定義
  #
  # TODO: ItamaeConf に移行が済んだ段階でこちらは削除。
  class HanaitaConfSub
    CONF_FILE = '/etc/bizside/hanaita.yml'

    def initialize
      conf_file = ENV['HANAITA_CONF'] || CONF_FILE
      @_conf = conf_file.then do |filename|
        next nil unless File.exist?(filename)
        YAML.respond_to?(:safe_load_file) ? YAML.safe_load_file(filename, aliases: true) : YAML.load_file(filename)
      end
    end

    def conf
      @_conf
    end
  end

  # /etc/bizside/hanaita.yml の on-memory モデル
  #
  # == SYNOPSIS
  # require 'itamae_plugin_recipe_bizside'
  # hanaita_conf(:a, :b, ...)   # Or
  # hanaita_conf('a.b...')
  #
  # == DESCRIPTION
  # /etc/bizside/hanaita.yml の hash に対するキー検索を行います。
  #
  # ファイルが存在しない場合は nil を返します。
  #
  # hanaita_conf(:a, :b) は意味的に hanaita.yml のハッシュに対する
  # アクセスhanaita_conf['a']['b'] と同等です。
  #
  # hanaita_conf(:a) が ハッシュでない場合(未定義または文字列や数値など)、
  # hanaita_conf(:a, :b) は単に nil を返します('undefined method `[]'
  # for nil:NilClass' とはなりません)。
  #
  # I18n#t と同様、'a.b' と言った文字列指定も可能です。
  #
  # == FILES
  # /etc/bizside/hanaita.yml::  設定ファイル
  class HanaitaConf < HanaitaConfSub
    include Singleton
  end

  # 各フェーズで hanaita_conf メソッド経由でアクセスできるようにするための
  # ユーティリティ。node メソッドと同様。
  module HanaitaConfAccessorMixin
    # 必要に応じて上書き
    def hanaita_conf_factory
      Bizside::HanaitaConf.instance
    end

    def hanaita_conf(*args)
      warn("DEPRECATED WARNING: 'hanaita_conf' is deprecated. " +
           "Use 'itamae_conf' instead.")
      if args.nil? || (args.is_a?(Array) && args[0].is_a?(Symbol) || args[0].nil?)
        hanaita_conf_sub(hanaita_conf_factory.conf, args)
      elsif args.is_a?(Array) && args[0].is_a?(String)
        hanaita_conf_sub(hanaita_conf_factory.conf, args[0].split('.').map{|s| s.to_sym})
      else
        raise 'unsupported argument type'
      end
    end

    private

    def hanaita_conf_sub(data, args)
      if args.size == 0
        data
      elsif data.is_a?(Hash)
        hanaita_conf_sub(data[args[0].to_s], args.drop(1))
      else
        nil
      end
    end

    def warn(msg)
      if defined?(Rails) and Rails.logger
        Rails.logger.warn(msg)
      else
        STDERR.print(msg, "\n")
      end
    end
  end
end
