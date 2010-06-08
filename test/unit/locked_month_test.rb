require 'test_helper'

class LockedMonthTest < ActiveSupport::TestCase
  test 'month_date' do
    april = Date.parse('2010-4-1')
    m = LockedMonth.new(:month => april)
    assert_nil(LockedMonth.find_by_month(april))
    assert m.save
    assert_equal(april, m.month)
    assert_not_nil(LockedMonth.find_by_month(april))
    
    may = Date.parse('2010-5-1')
    m = LockedMonth.new(:month => Date.parse('2010-5-13'))
    assert m.save
    assert_equal(may, m.month)
    assert_not_nil(LockedMonth.find_by_month(may))
  end
  
  test 'no_duplicates' do
    april = Date.parse('2010-4-1')
    m = LockedMonth.new(:month => april)
    assert m.save
    
    m = LockedMonth.new(:month => april)
    assert !m.save
    assert_not_nil(m.errors['month'])
    
    m = LockedMonth.new(:month => Date.parse('2010-4-15'))
    assert !m.save
    assert_not_nil(m.errors['month'])
  end
end
