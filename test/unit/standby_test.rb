require 'test_helper'

class StandbyTest < ActiveSupport::TestCase
  def setup
    @one = standbys(:one)
    @two = standbys(:two)
    @m1 = members(:one)
    @one.member = @m1
    @two.member = @m1
  end
  
  test "require_start_time" do
    @one.start_time = nil
    assert(!@one.save)
    assert_not_nil(@one.errors['start_time'])
  end

  test "get_date_from_start_time" do
    s = Standby.create
    assert_nil(s.date)

    s.start_time = get_time
    assert_equal(s.date, s.start_time.beginning_of_day.to_date)
  end

  test "dont_require_end_time" do
    end_time = @one.end_time
    @one.end_time = nil
    assert(@one.save)

    @one.end_time = end_time
    assert(@one.save, @one.errors.inspect)
    assert_equal(@one.end_time, end_time)
  end

  test "less_than_four_hours" do
    m = Member.create(:firstname => 'Bob',
                      :lastname => 'Jones',
                      :badgeno => '532103')
    t = Standby.new(:start_time => Time.local(2010, 3, 20, 7, 0, 0),
                    :end_time => Time.local(2010, 3, 20, 11, 0, 0),
                    :member_id => m.id)
    assert(t.save)
    assert_equal(1, t.points)

    t2 = Standby.new(:start_time => Time.local(2010, 3, 21, 7, 0, 0),
                     :end_time => Time.local(2010, 3, 21, 10, 0, 0),
                     :member_id => m.id)
    assert(t2.save)
    assert_equal(0, t2.points)
    
    t2.end_time = Time.local(2010, 3, 21, 10, 59, 59)
    assert(t2.save)
    assert_equal(0, t2.points)
  end

  test "start_before_end" do
    t = get_time
    @one.end_time = t
    @one.start_time = t + 1.hour
    assert(!@one.save)
    assert_not_nil(@one.errors['end_time'])
  end

  test "next_morning" do
    m = Member.create(:firstname => 'bob', 
                      :lastname => 'jones', 
                      :badgeno => '532103')
    sb = Standby.new(:start_time => Time.local(2010, 4, 13, 18, 0, 0),
                     :end_time => Time.local(2010, 4, 13, 23, 0, 0),
                     :member_id => m.id)
    assert(sb.valid?)

    sb.end_time = Time.local(2010, 4, 14, 6, 59, 59)
    assert(sb.valid?)
    
    sb.end_time = Time.local(2010, 4, 14, 7, 0, 0)
    assert(!sb.valid?)
  end

  test "points" do
    [@one, @two].each do |s|
      assert_equal(s.points, 1)
    end

    @one.end_time = nil
    assert(@one.save, @one.errors.inspect)
    assert_nil(@one.points)

    sb = Standby.new(:start_time => Time.local(2010, 4, 13, 7, 0, 0),
                     :end_time => Time.local(2010, 4, 13, 10, 59, 59))
    assert_equal(0, sb.points)
    assert_equal(0, sb.hours)
    
    sb.end_time = Time.local(2010, 4, 13, 11, 0, 0)
    assert_equal(1, sb.points)
    assert_equal(4, sb.hours)

    sb.deleted = true
    assert_equal(0, sb.points)
  end
  
  test "hours" do
    assert_equal(@one.hours, 4)
    assert_equal(@two.hours, 12)
    
    t = get_time
    @one.start_time = t
    @one.end_time = t + 7.5.hours
    assert_equal(@one.hours, 7.5)

    @one.deleted = true
    assert_equal(0, @one.hours)
    @one.deleted = false

    @one.end_time = nil
    assert_nil(@one.hours)

  end

  test "no_overlap" do
    m = members(:one)

    # Two windows, overlapping left
    start1 = Time.local(2009, 04, 25, 15, 00, 00)
    end1 = start1 + 6.hours
    start2 = start1 - 2.hours
    end2 = start2 + 6.hours

    sb1 = Standby.new(:start_time => start1,
                      :end_time => end1,
                      :member_id => m.id)
    assert(sb1.save, sb1.errors)
    
    sb2 = Standby.new(:start_time => start2,
                      :end_time => end2,
                      :member_id => m.id)

    assert(!sb2.save)
    assert_not_nil(sb2.errors['end_time'])

    # Overlapping right
    start2 = start1 + 2.hours
    end2 = start2 + 6.hours

    sb2.update_attributes(:start_time => start2,
                         :end_time => end2)
    assert(!sb2.save)
    assert_not_nil(sb2.errors['start_time'])

    # Overlapping enclosing
    start2 = start1 - 2.hours
    end2 = end1 + 2.hours
    sb2.update_attributes(:start_time => start2,
                          :end_time => end2)
    assert(!sb2.save)
    assert_not_nil(sb2.errors['end_time'])

    # Boundary collision left
    start2 = start1 - 4.hours
    end2 = start1
    sb2.update_attributes(:start_time => start2,
                          :end_time => end2)
    assert(!sb2.save)
    assert_not_nil(sb2.errors['end_time'])

    # Boundary collision right
    start2 = end1
    end2 = end1 + 4.hours
    sb2.update_attributes(:start_time => start2,
                          :end_time => end2)
    assert(!sb2.save)
    assert_not_nil(sb2.errors['start_time'])

    # Deleted
    sb1.deleted = true
    assert(sb1.save)
    assert(sb2.save)
  end

  test 'no_overlap_with_sleep_in' do
    m1 = members(:one)
    assert_not_nil(m1)

    si = SleepIn.new(:date => Date.today - 30.days, :unit => 'Engine')
    si.member = m1
    assert si.save

    sb = Standby.new(:start_time => Date.today - 30.days + 13.hours,
                     :end_time => Date.today - 30.days + 18.hours)
    sb.member = m1
    assert(sb.save)
    assert(sb.destroy)

    sb = Standby.new(:start_time => Date.today - 30.days + 13.hours,
                     :end_time => Date.today - 30.days + 19.hours)
    sb.member = m1
    assert(sb.save)
    assert(sb.destroy)

    sb = Standby.new(:start_time => Date.today - 30.days + 13.hours,
                     :end_time => Date.today - 30.days + 20.hours)
    sb.member = m1
    assert(!sb.save)
    
    sb = Standby.new(:start_time => Date.tomorrow - 30.days + 8.hours,
                     :end_time => Date.tomorrow - 30.days + 12.hours)
    sb.member = m1
    assert(sb.save)
    assert(sb.destroy)
    
    sb = Standby.new(:start_time => Date.tomorrow - 30.days + 7.hours,
                     :end_time => Date.tomorrow - 30.days + 11.hours)
    sb.member = m1
    assert(sb.save)
    assert(sb.destroy)
    
    sb = Standby.new(:start_time => Date.tomorrow - 30.days + 3.hours,
                     :end_time => Date.tomorrow - 30.days + 8.hours)
    sb.member = m1
    assert(!sb.save)

    sb = Standby.new(:start_time => Date.tomorrow - 30.days + 3.hours,
                     :end_time => Date.tomorrow - 30.days + 7.hours)
    sb.member = m1
    assert(!sb.save)
    
    sb = Standby.new(:start_time => Date.tomorrow - 30.days,
                     :end_time => Date.tomorrow - 30.days + 5.hours)
    sb.member = m1
    assert(!sb.save)

    sb = Standby.new(:start_time => Date.today - 30.days + 17.hours,
                     :end_time => Date.today - 30.days + 19.hours)
    sb.member = m1
    assert(sb.save)

    si.deleted = true
    assert(si.save)
    sb = Standby.new(:start_time => Date.tomorrow - 30.days,
                     :end_time => Date.tomorrow - 30.days + 5.hours)
    sb.member = m1
    assert(sb.save)    
  end

  test 'no_future_months' do
    sb = Standby.new(:start_time => Date.today,
                     :end_time => Date.today + 4.hours,
                     :member_id => @m1.id)
    assert(sb.save)
    sb.destroy

    sb = Standby.new(:start_time => Date.today.end_of_month,
                     :end_time => Date.today.end_of_month + 4.hours,
                     :member_id => @m1.id)
    assert(sb.save)
    sb.destroy

    sb = Standby.new(:start_time => Date.today.next_month.beginning_of_month,
                     :end_time => Date.today.next_month.beginning_of_month + 4.hours,
                     :member_id => @m1.id)
    assert(!sb.save)
  end

  test 'dates' do
    sb = Standby.new(:start_date => '4/15/2010',
                     :end_date => '4/15/2010',
                     :start_time => Time.local(2010, 4, 5, 7, 0, 0),
                     :end_time => Time.local(2010, 4, 5, 12, 0, 0),
                     :member_id => @m1.id)
    assert(sb.save)
    assert_equal(Time.local(2010, 4, 15, 7, 0, 0), sb.start_time)
    assert_equal(Time.local(2010, 4, 15, 12, 0, 0), sb.end_time)    

    sb = Standby.new(:start_date => '4/16/2010',
                     :end_date => '4/17/2010',
                     :start_time => Time.local(2010, 4, 20, 19, 0, 0),
                     :end_time => Time.local(2010, 4, 20, 3, 0, 0),
                     :member_id => @m1.id)
    assert(sb.save)
    assert_equal(Time.local(2010, 4, 16, 19, 0, 0), sb.start_time)
    assert_equal(Time.local(2010, 4, 17, 3, 0, 0), sb.end_time)
  end

  private
  def get_time
    t = Time.now
    t += 5.hours if t.hour < 5
    t
  end
end
