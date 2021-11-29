require 'test_helper'

class Bizside::ConfigTest < ActiveSupport::TestCase

  def test_prefix
    assert_equal '/', Bizside::Config.new.prefix
  end

  def 存在しない属性のget
    assert_nil Bizside::Config.new().any_attr
  end

  def 存在しない属性の代入
    config = Bizside::Config.new()
    config.any_attr = 'some value'
    assert_equal 'some value', config.any_attr
  end

  def 存在しない属性のset
    config = Bizside::Config.new()
    config.any_attr('some value')
    assert_equal 'some value', config.any_attr
  end

  def 存在する属性のget
    assert_equal 123, Bizside::Config.new({ any_attr: 123 }).any_attr
  end

  def 存在する属性の代入_上書き
    config = Bizside::Config.new({ any_attr: 123 })
    config.any_attr = 456
    assert_equal 456, config.any_attr
  end

  def 存在する属性のset
    config = Bizside::Config.new({ any_attr: 123 })
    config.any_attr(456)
    assert_equal 456, config.any_attr
  end

  def 存在しない名前空間_存在しない属性_のget
    assert_nil Bizside::Config.new().any_namespace.any_attr
  end

  def 存在しない名前空間_存在しない属性_の代入
    config = Bizside::Config.new()
    config.any_namespace.any_attr = 'some value'
    assert_equal 'some value', config.any_namespace.any_attr
  end

  def 存在しない名前空間_存在しない属性_のset
    config = Bizside::Config.new()
    config.any_namespace.any_attr('some value')
    assert_equal 'some value', config.any_namespace.any_attr
  end

  def 存在する名前空間_存在しない属性_のget
    assert_nil Bizside::Config.new({ any_namespace: {} }).any_namespace.any_attr
  end

  def 存在する名前空間_存在しない属性_の代入
    config = Bizside::Config.new({ any_namespace: {} })
    config.any_namespace.any_attr = 'some value'
    assert_equal 'some value', config.any_namespace.any_attr
  end

  def 存在する名前空間_存在しない属性_のset
    config = Bizside::Config.new({ any_namespace: {} })
    config.any_namespace.any_attr('some value')
    assert_equal 'some value', config.any_namespace.any_attr
  end

  def 存在する名前空間_存在する属性_のget
    assert_equal 123, Bizside::Config.new({ any_namespace: { any_attr: 123 } }).any_namespace.any_attr
  end

  def 存在する名前空間_存在する属性_の代入
    config = Bizside::Config.new({ any_namespace: { any_attr: 123 } })
    config.any_namespace.any_attr = 456
    assert_equal 456, config.any_namespace.any_attr
  end

  def 存在する名前空間_存在する属性_のset
    config = Bizside::Config.new({ any_namespace: { any_attr: 123 } })
    config.any_namespace.any_attr(456)
    assert_equal 456, config.any_namespace.any_attr
  end
end
