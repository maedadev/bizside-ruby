require 'test_helper'

class GengouTest < ActiveSupport::TestCase
  
  def test_good
    [
      '* * * * *',
      '*/1 * * * *',
      '0 0 1 1 0',
      '59 23 31 12 7',
      '0,15 * * * *',
      '0-30 * * * *',
      '0/120 * * * *',
      '0,10-20 * * * *',
      '0,10-20/2 * * * *'
    ].each do |line|
      validator = CronValidator.new(line)
      assert validator.valid?
    end
  end
  
  def test_bad
    [
      '-1 * * * *',
      '60 * * * *',
      '* -1 * * *',
      '* 24 * * *',
      '* * 0 * *',
      '* * 32 * *',
      '* * * 0 *',
      '* * * 13 *',
      '* * * * -1',
      '* * * * 8',
      'a * * * *',
      ''
      ].each do |line|
        validator = CronValidator.new(line)
        assert ! validator.valid?
      end
  end
  
end
