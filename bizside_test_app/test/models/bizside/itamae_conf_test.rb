require 'test_helper'
require 'bizside/itamae_conf'

module Bizside
  class ItamaeConfTest < ActiveSupport::TestCase
    class TestAccessor
      include ::Bizside::ItamaeConfAccessorMixin

      # ItamaeConf ではなく ItamaeConfSubを使用(テスト目的)
      def itamae_conf_factory
        @_itamae_conf ||= ::Bizside::ItamaeConfSub.new
      end
    end

    def test_itamae_conf_work
      ENV['ROLE'] = 'app'
      ENV['ITAMAE_CONFS'] = ['../../data/hanaita.yml',
                             '../../data/itamae.yml',
                             '../../data/database.yml',
                            ].map{|path| File.join(File.dirname(__FILE__), path)}.
                             join(' ')
      t = TestAccessor.new

      # itamae_conf メソッドは hash を返す
      assert t.itamae_conf.is_a?(Hash)

      # itamae_conf(a,b,...) が期待する値を返す
      assert t.itamae_conf(:log).is_a?(Hash)
      assert t.itamae_conf(:log, :upload).is_a?(Hash)
      assert_equal 'aws-es', t.itamae_conf(:log, :upload, :host_type)
      assert_equal 'dummy_id', t.itamae_conf(:log, :upload, :aws, :access_key_id)

      # 存在しないキーに対しては nil を返す
      assert_nil t.itamae_conf(:other)

      # 親が nil の場合、子キーまで指定しても nil を返す
      assert_nil t.itamae_conf(:other, :dummy)

      # string 形式
      assert t.itamae_conf('log').is_a?(Hash)
      assert t.itamae_conf('log.upload').is_a?(Hash)
      assert_equal 'aws-es', t.itamae_conf('log.upload.host_type')
      assert_equal 'dummy_id', t.itamae_conf('log.upload.aws.access_key_id')
      assert_nil t.itamae_conf('other')
      assert_nil t.itamae_conf('other.dummy')

      # itamae.yml 設定
      assert_equal 'localhost',   t.itamae_conf('zabbix.agent.hosts')['127.0.0.1']
      assert_equal 'localhost2',  t.itamae_conf('zabbix.agent.hosts')['127.0.0.2']
      assert_equal 'httpd',       t.itamae_conf('web_server_type')
      assert_equal true,          t.itamae_conf('zabbix.agent.log_watch.install')
      assert_equal false,         t.itamae_conf('zabbix.agent.mysql.install')

      # database.yml 設定
      assert_equal 'dummy_test',  t.itamae_conf('db.database')
      assert_equal 'dummy',       t.itamae_conf('db.username')

      # ERBは評価されている
      assert_match /^\d+$/,       t.itamae_conf('db.pool').to_s

      ENV['ROLE'] = nil
    end

    # /etc/bizside/hanaita.yml が存在しない場間、itamae_conf は nil を返す
    def test_itamae_conf_on_no_yml
      file_path = '/THIS/FILE/NEVER/EXIST'
      ENV['ITAMAE_CONFS'] = file_path
      assert !File.exist?(ENV['ITAMAE_CONFS'])

      t = TestAccessor.new
      assert_output(nil, "WARN: #{file_path} does NOT exist.\n") do
        assert_nil t.itamae_conf
      end

      assert_nil t.itamae_conf(:log)
    end

    # ROLE無しの場合もエラーにはならず
    def test_itamae_conf_work_without_role
      ENV['ITAMAE_CONFS'] = ['../../data/hanaita.yml',
                             '../../data/itamae.yml',
                            ].map{|path| File.join(File.dirname(__FILE__), path)}.
                             join(' ')
      t = TestAccessor.new

      # itamae_conf メソッドは hash を返す
      assert t.itamae_conf.is_a?(Hash)

      # itamae_conf(a,b,...) が期待する値を返す
      assert t.itamae_conf(:log).is_a?(Hash)
      assert t.itamae_conf(:log, :upload).is_a?(Hash)
      assert_equal 'aws-es', t.itamae_conf(:log, :upload, :host_type)
      assert_equal 'dummy_id', t.itamae_conf(:log, :upload, :aws, :access_key_id)

      # 存在しないキーに対しては nil を返す
      assert_nil t.itamae_conf(:other)

      # 親が nil の場合、子キーまで指定しても nil を返す
      assert_nil t.itamae_conf(:other, :dummy)

      # itamae.yml 設定
      assert_nil t.itamae_conf('zabbix.agent.hosts')
    end

    # add_on_name 無しの場合もエラーにはならず
    def test_itamae_conf_work_without_add_on_name
      ENV['ITAMAE_CONFS'] = nil

      assert_match /hanaita.yml$/,  Bizside::ItamaeConf.conf_files[0]
      assert_match /itamae.yml$/,   Bizside::ItamaeConf.conf_files[1]
      assert_match /database.yml$/, Bizside::ItamaeConf.conf_files[2]
    end

    def test_set_itamae_conf
      ENV['ITAMAE_CONFS'] = File.dirname(__FILE__) + '/../../data/hanaita.yml'
      t = TestAccessor.new
      assert_equal 'aws-es', t.itamae_conf('log.upload.host_type')

      t.set_itamae_conf('log.upload.new_key', '**NEW-VALUE**')
      assert_equal '**NEW-VALUE**', t.itamae_conf('log.upload.new_key')

      t.set_itamae_conf('log.upload.add_on.path', '**NEW-PATH**')
      assert_equal '**NEW-PATH**', t.itamae_conf('log.upload.add_on.path')

      # 既存値の上書きは不可
      assert_raises(Bizside::ItamaeConf::OverWriteError){
        t.set_itamae_conf('log.upload.new_key', '**NEW-VALUE**99')
      }
    end
  end
end
