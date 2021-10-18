require 'test_helper'

class Bizside::ConfigTest < ActiveSupport::TestCase

  def test_prefix
    assert_equal '/', Bizside::Config.new.prefix
  end

end