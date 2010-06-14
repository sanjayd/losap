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
  
  test 'order' do
    LockedMonth.delete_all
    
    m1 = LockedMonth.create(:month => 3.months.ago.to_date.beginning_of_month)
    m2 = LockedMonth.create(:month => 5.months.ago.to_date.beginning_of_month)
    m3 = LockedMonth.create(:month => 4.months.ago.to_date.beginning_of_month)
    
    assert_equal(3, LockedMonth.count)
    
    months = LockedMonth.locked_in_last_six_months
    assert_equal(m1, months[0])
    assert_equal(m3, months[1])
    assert_equal(m2, months[2])
  end
  
  test 'locked?' do
    assert LockedMonth.locked? Date.parse('2010-5-1')
    assert LockedMonth.locked? Date.parse('2010-5-15')
    assert !(LockedMonth.locked?(Date.parse('2010-6-25')))
  end
end
