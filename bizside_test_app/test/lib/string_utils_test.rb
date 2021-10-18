require 'test_helper'

class StringUtilsTest < ActiveSupport::TestCase
  
  def test_rand_string
    s = StringUtils.rand_string
    assert s =~ /^(?=.*?[a-z])(?=.*?\d).*+$/iu
  end

end
