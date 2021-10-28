require 'test_helper'

class Bizside::StringUtilsTest < ActiveSupport::TestCase
  
  def test_rand_string
    s = Bizside::StringUtils.rand_string
    assert s =~ /^(?=.*?[a-z])(?=.*?\d).*+$/iu
  end

end
