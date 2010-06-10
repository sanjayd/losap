require 'test_helper'

class LockedMonthTest < ActiveSupport::TestCase
  test 'month_date' do
    april = Date.parse('2010-4-1')
    m = LockedMonth.new(:month => april)
    assert_nil(LockedMonth.find_by_month(april))
    assert m.save
    assert_equal(april, m.month)
    assert_not_nil(LockedMonth.find_by_month(april))
    
    may = Date.parse('2010-3-1')
    m = LockedMonth.new(:month => Date.parse('2010-3-13'))
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
  
  test 'two_years_ago' do
    month = LockedMonth.new(:month => (2.years.ago + 1.month).to_date)
    assert(month.save)
    month = LockedMonth.new(:month => (2.years.ago - 1.month).to_date)
    
    months = LockedMonth.last_two_years
    assert_not_nil(months)
    assert_equal(3, months.size)
  end

  test 'order' do
    m1 = LockedMonth.create(:month => Date.parse('2009-12-1'))
    m2 = LockedMonth.create(:month => Date.parse('2009-10-1'))
    m3 = LockedMonth.create(:month => Date.parse('2009-11-1'))
    
    assert_equal(5, LockedMonth.count)
    
    months = LockedMonth.last_two_years
    assert_equal(locked_months(:one), months[0])
    assert_equal(locked_months(:two), months[1])
    assert_equal(m1, months[2])
    assert_equal(m3, months[3])
    assert_equal(m2, months[4])
  end
  
  test 'locked?' do
    assert LockedMonth.locked? Date.parse('2010-6-1')
    assert LockedMonth.locked? Date.parse('2010-6-15')
    assert !(LockedMonth.locked?(Date.parse('2010-4-25')))
  end
end
