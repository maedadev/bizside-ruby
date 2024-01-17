require 'test_helper'

class Bizside::CronValidatorTest < ActiveSupport::TestCase
  
  def test_good
    [
      '* * * * *',
      '*/1 * * * *',
      '0 0 1 1 0',
      '59 23 31 12 7',
      '0,15 * * * *',
      '0-30 * * * *',
      '0/59 * * * *',
      '0,10-20 * * * *',
      '0,10-20/2 * * * *',
      '* 1,3,5,7,9,11,13,15,17,19,21,23 * * *',
    ].each do |line|
      validator = Bizside::CronValidator.new(line)
      assert validator.valid?, line
    end
  end
  
  def test_bad
    [
      '-1 * * * *',
      '60 * * * *',
      '* -1 * * *',
      '* 24 * * *',
      '* */24 * * *',
      '* */0 * * *',
      '* * 0 * *',
      '* * 32 * *',
      '* * * 0 *',
      '* * * 13 *',
      '* * * * -1',
      '* * * * 8',
      'a * * * *',
      '',
      '* 1,3,5,7,9,11,13,15,17,19,21,23,25 * * *',
      ].each do |line|
        validator = Bizside::CronValidator.new(line)
        assert ! validator.valid?, line
      end
  end
  
end
