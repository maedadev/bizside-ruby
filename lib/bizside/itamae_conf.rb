require 'singleton'
require 'yaml'

module Bizside
  # itamae_conf をテストするため、 singleton 以前のクラスを定義
  #
  # TODO: HanaitaConf と類似していますが HanaitaConf は obsolete 予定なので
  # 敢えて refactoring はやっていません。
  class ItamaeConfSub
    class << self
      # base..derived の順
      def conf_files
        if ENV['ITAMAE_CONFS']
          ENV['ITAMAE_CONFS'].split
        else
          result = ['/etc/bizside/hanaita.yml']
          add_yml(result, 'itamae.yml')
          add_yml(result, 'database.yml')
          result
        end
      end

      private

      # shared/*.yml を優先して指定。存在しない時にのみ config/*.yml を指定。
      def add_yml(paths, basename)
        candidates = []
        candidates << File.join(ENV['DEPLOY_TO'], 'shared', basename).to_s unless ENV['DEPLOY_TO'].to_s.empty?
        candidates << File.join('config', basename).to_s

        candidates.each do |path|
          if File.exist?(path)
            paths << path
            break
          end
        end
      end
    end

    def initialize
      for conf_file in self.class.conf_files do
        if File.exist?(conf_file)
          @_conf ||= {}
          text = ERB.new(File.read(conf_file)).result
          hash = YAML.respond_to?(:unsafe_load) ? YAML.unsafe_load(text) : YAML.load(text)

          case conf_file
          # itamae.yml スペシャルロジック。ROLE必須。
          when /itamae.yml$/
            role = ENV['ROLE']
            next if role.nil? || role.empty?
            hash = hash[role]

          # database.yml スペシャルロジック。例:
          #
          # database.yml::  RAILS_ENV.adapter
          # ↓::             ↓
          # itamae_conf::   db.adapter
          when /database.yml$/
            partial = hash[Bizside.env]
            hash = {'db' => partial.dup} if partial
          end
          deep_merge!(@_conf, hash) if hash
        else
          $stderr.printf("WARN: %s does NOT exist.\n", conf_file)
        end
      end
    end

    def conf
      @_conf
    end

    private

    # (c)Rails
    def deep_merge(h1, h2, &block)
      deep_merge!(h1.dup, h2, &block)
    end

    # (c)Rails
    def deep_merge!(h1, h2, &block)
      h2.each_pair do |current_key, other_value|
        this_value = h1[current_key]
        h1[current_key] = if this_value.is_a?(Hash) && other_value.is_a?(Hash)
                            deep_merge(this_value, other_value, &block)
                          else
                            if block_given? && key?(current_key)
                              block.call(current_key, this_value, other_value)
                            else
                              other_value
                            end
                          end
      end
      h1
    end
  end

  # 各種 yml を１つの hash にマージした on-memory モデル:
  #
  # == SYNOPSIS
  # require 'itamae_plugin_recipe_bizside'
  # itamae_conf(:a, :b, ...)   # Or
  # itamae_conf('a.b...')
  #
  # == DESCRIPTION
  # yaml設定ファイル(後述。FILES節参照) の hash に対するキー検索を行います。
  #
  # ファイルが存在しない場合は nil を返します。
  #
  # itamae_conf(:a, :b) は意味的に itamae.yml のハッシュに対する
  # アクセスitamae_conf['a']['b'] と同等です。
  #
  # itamae_conf(:a) が ハッシュでない場合(未定義または文字列や数値など)、
  # itamae_conf(:a, :b) は単に nil を返します('undefined method `[]'
  # for nil:NilClass' とはなりません)。
  #
  # I18n#t と同様、'a.b' と言った文字列指定も可能です。
  #
  # == FILES
  # config/database.yml::                       設定ファイル-1(*1)
  # config/itamae.yml::                         設定ファイル-2(*2)
  # /etc/bizside/hanaita.yml::                  設定ファイル-3
  #
  # (*1) RAILS_ENV に該当する部分のみ 'db' エントリの下に読み込みます。
  # (*2) 指定された ROLE のみ読み込みます。
  class ItamaeConf < ItamaeConfSub
    class OverWriteError < StandardError; end

    include Singleton
  end

  # 各フェーズで itamae_conf メソッド経由でアクセスできるようにするための
  # ユーティリティ。node メソッドと同様。
  module ItamaeConfAccessorMixin
    # 必要に応じて上書き
    def itamae_conf_factory
      Bizside::ItamaeConf.instance
    end

    def itamae_conf(*args)
      if args.nil? || (args.is_a?(Array) && args[0].is_a?(Symbol) || args[0].nil?)
        itamae_conf_sub(itamae_conf_factory.conf, args)
      elsif args.is_a?(Array) && args[0].is_a?(String)
        itamae_conf_sub(itamae_conf_factory.conf, args[0].split('.').map{|s| s.to_sym})
      else
        raise 'unsupported argument type'
      end
    end

    # itamae_conf に値をセットします。
    #
    # 安易な上書きを避けるため、既存値が存在する場合は OverWriteError としています。
    #
    # 簡単化のため、シンボル指定(set_itamae_conf(:a, :b, ..., value))はサポートしていません
    # (itamae_conf と違って)。
    def set_itamae_conf(key, value)
      raise 'まだ用途が定まっていないので、使用不可です。' unless Bizside.env == 'test'
      set_itamae_conf_sub(itamae_conf_factory.conf, key.split('.'), key, value)
    end

    private

    def itamae_conf_sub(data, args)
      if args.size == 0
        data
      elsif data.is_a?(Hash)
        itamae_conf_sub(data[args[0].to_s], args.drop(1))
      else
        nil
      end
    end

    # ここで key は単にエラーメッセージ用途
    def set_itamae_conf_sub(hash, args, key, value)
      arg0 = args[0]
      if args.size == 1
        raise ItamaeConf::OverWriteError.new("duplicate on #{key}") if hash[arg0]

        hash[arg0] = value
      else
        hash[arg0] = {} if hash[arg0].nil?
        set_itamae_conf_sub(hash[arg0], args.drop(1), key, value)
      end
    end
  end
end
