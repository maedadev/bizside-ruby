require 'test_helper'
require 'bizside/hanaita_conf'

module Bizside
  class HanaitaConfTest < ActiveSupport::TestCase
    class TestAccessor
      include ::Bizside::HanaitaConfAccessorMixin
  
      # HanaitaConf ではなく HanaitaConfSubを使用(テスト目的)
      def hanaita_conf_factory
        @_hanaita_conf ||= ::Bizside::HanaitaConfSub.new
      end
    end
  
    def test_hanaita_conf_work
      ENV['HANAITA_CONF'] = File.join(File.dirname(__FILE__), '../../data/hanaita.yml')
      t = TestAccessor.new

      # hanaita_conf メソッドは hash を返す
      assert t.hanaita_conf.is_a?(Hash)
  
      # hanaita_conf(a,b,...) が期待する値を返す
      assert t.hanaita_conf(:log).is_a?(Hash)
      assert t.hanaita_conf(:log, :upload).is_a?(Hash)
      assert_equal 'aws-es', t.hanaita_conf(:log, :upload, :host_type)
      assert_equal 'dummy_id', t.hanaita_conf(:log, :upload, :aws, :access_key_id)
  
      # 存在しないキーに対しては nil を返す
      assert_nil t.hanaita_conf(:other)
  
      # 親が nil の場合、子キーまで指定しても nil を返す
      assert_nil t.hanaita_conf(:other, :dummy)

      # string 形式
      assert t.hanaita_conf('log').is_a?(Hash)
      assert t.hanaita_conf('log.upload').is_a?(Hash)
      assert_equal 'aws-es', t.hanaita_conf('log.upload.host_type')
      assert_equal 'dummy_id', t.hanaita_conf('log.upload.aws.access_key_id')
      assert_nil t.hanaita_conf('other')
      assert_nil t.hanaita_conf('other.dummy')
    end
  
    # /etc/bizside/hanaita.yml が存在しない場間、hanaita_conf は nil を返す
    def test_hanaita_conf_on_no_yml
      ENV['HANAITA_CONF'] = '/THIS/FILE/NEVER/EXIST'
      assert !File.exist?(ENV['HANAITA_CONF'])
  
      t = TestAccessor.new
      assert_nil t.hanaita_conf
      assert_nil t.hanaita_conf(:log)
    end
  end
end
