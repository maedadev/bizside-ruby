require 'test_helper'

class Bizside::StringUtilsTest < ActiveSupport::TestCase
  
  def test_rand_string
    s = Bizside::StringUtils.rand_string
    assert s =~ /^(?=.*?[a-z])(?=.*?\d).*+$/iu
  end

  def test_create_random_alpha_string_case_sensitive_true
    s = StringUtils.create_random_alpha_string(10, true)
    assert s =~ /\A[A-Za-z]{10}\z/
  end

  def test_create_random_alpha_string_case_sensitive_false
    s = StringUtils.create_random_alpha_string(10, false)
    assert s =~ /\A[a-z]{10}\z/
  end

  def test_create_random_alpha_string_more_than_26_chars
    s = StringUtils.create_random_alpha_string(53, true)
    assert s =~ /\A[A-Za-z]{53}\z/

    s = StringUtils.create_random_alpha_string(27, false)
    assert s =~ /\A[a-z]{27}\z/
  end
end
