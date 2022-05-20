require 'test_helper'
require 'bizside/task_helper'

# メソッドは全てトップレベルに定義されるため、mainオブジェクトを参照する方法を用意
MAIN_OBJECT = self

class Bizside::TaskHelperTest < ActiveSupport::TestCase
  def test_yes_confirmed_true
    assert MAIN_OBJECT.yes_confirmed?('yes')
    assert MAIN_OBJECT.yes_confirmed?('Yes')
    assert MAIN_OBJECT.yes_confirmed?('YES')
    assert MAIN_OBJECT.yes_confirmed?('y')
    assert MAIN_OBJECT.yes_confirmed?('Y')
    assert MAIN_OBJECT.yes_confirmed?('true')
    assert MAIN_OBJECT.yes_confirmed?('TRUE')
    assert MAIN_OBJECT.yes_confirmed?(true)
  end

  def test_yes_confirmed_false
    assert_not MAIN_OBJECT.yes_confirmed?('no')
    assert_not MAIN_OBJECT.yes_confirmed?('No')
    assert_not MAIN_OBJECT.yes_confirmed?('NO')
    assert_not MAIN_OBJECT.yes_confirmed?('n')
    assert_not MAIN_OBJECT.yes_confirmed?('N')
    assert_not MAIN_OBJECT.yes_confirmed?('false')
    assert_not MAIN_OBJECT.yes_confirmed?('FALSE')
    assert_not MAIN_OBJECT.yes_confirmed?(false)
  end

  def test_yes_confirmed_fali_on_error
    options = { fail_on_error: true }
    template = 'yes/no または true/false 形式で入力してください。answer=%<answer>s'

    assert MAIN_OBJECT.yes_confirmed?('yes', options)

    assert_not MAIN_OBJECT.yes_confirmed?('no', options)

    assert_equal format(template, answer: 'ok'),
                 assert_raise(RuntimeError) { MAIN_OBJECT.yes_confirmed?('ok', options) }.message
    assert_equal format(template, answer: 'OK'),
                 assert_raise(RuntimeError) { MAIN_OBJECT.yes_confirmed?('OK', options) }.message
    assert_equal format(template, answer: 'ng'),
                 assert_raise(RuntimeError) { MAIN_OBJECT.yes_confirmed?('ng', options) }.message
    assert_equal format(template, answer: 'NG'),
                 assert_raise(RuntimeError) { MAIN_OBJECT.yes_confirmed?('NG', options) }.message
  end
end
