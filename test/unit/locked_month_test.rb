require 'test_helper'

class LockedMonthTest < ActiveSupport::TestCase
  test 'month_date' do
    march = Date.parse('2010-3-1')
    m = LockedMonth.new(:month => march)
    assert_nil(LockedMonth.find_by_month(march))
    assert m.save
    assert_equal(march, m.month)
    assert_not_nil(LockedMonth.find_by_month(march))
    
    june = Date.parse('2010-6-1')
    m = LockedMonth.new(:month => Date.parse('2010-6-13'))
    assert m.save
    assert_equal(june, m.month)
    assert_not_nil(LockedMonth.find_by_month(june))
  end
  
  test 'no_duplicates' do
    march = Date.parse('2010-3-1')
    m = LockedMonth.new(:month => march)
    assert m.save
    
    m = LockedMonth.new(:month => march)
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
    assert_equal(locked_months(:one).month, months[0])
    assert_equal(locked_months(:two).month, months[1])
    assert_equal(m1.month, months[2])
    assert_equal(m3.month, months[3])
    assert_equal(m2.month, months[4])
  end
  
  test 'locked?' do
    assert LockedMonth.locked? Date.parse('2010-5-1')
    assert LockedMonth.locked? Date.parse('2010-5-15')
    assert !(LockedMonth.locked?(Date.parse('2010-6-25')))
  end
end
