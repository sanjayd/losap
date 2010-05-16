require 'test_helper'

class SleepInTest < ActiveSupport::TestCase
  def setup
    @one = sleep_ins(:one)
    @two = sleep_ins(:two)
    @three = sleep_ins(:three)
    @four = sleep_ins(:four)
    @m1 = members(:one)
  end

  test "require date" do
    @one.date = nil
    assert(!@one.save)
    assert_not_nil(@one.errors['date'])
  end

  test "require_unit" do
    @one.unit = nil
    assert(!@one.save)
    assert_not_nil(@one.errors['unit'])
  end

  test "unique_for_member" do
    si = SleepIn.new
    si.date = @one.date
    si.unit = 'Ambulance'
    si.member_id = @one.member_id
    assert(!si.save)
    assert_not_nil(si.errors['date'])

    si.unit = @one.unit
    assert(!si.save)
    assert_not_nil(si.errors['date'])
  end

  test "no_future_months" do
    si = SleepIn.new(:date => Date.today, :unit => 'Engine')
    assert(si.save)
    si.destroy
    
    si = SleepIn.new(:date => Date.today - 1.month, :unit => 'Engine')
    assert(si.save)
    si.destroy

    si = SleepIn.new(:date => Date.today.end_of_month, :unit => 'Engine')
    assert(si.save)
    si.destroy
    
    si = SleepIn.new(:date => (Date.today + 1.month).beginning_of_month, :unit => 'Engine')
    assert(!si.save)
    si.destroy

    si = SleepIn.new(:date => Date.today + 1.month, :unit => 'Engine')
    assert(!si.save)
  end

  test "unit_names" do
    @one.unit = 'Engine'
    @one.member = @m1
    assert(@one.save)
    @one.unit = 'Truck'
    assert(@one.save)
    @one.unit = 'Ambulance'
    assert(@one.save)
    @one.unit = 'Somethingelse'
    assert(!@one.save)
    assert_not_nil(@one.errors['unit'])
  end

  test "belongs_to_member" do
    member = members(:one)

    @one.member = member
    @one.save

    si = SleepIn.new
    si.unit = 'Engine'
    si.date = '2008-09-01'
    si.member = @one.member
    si.save

    assert_equal(si.member_id, @one.member_id)
  end

  test "hours" do
    [@one, @two, @three, @four].each do |s|
      assert_equal(s.hours, 12)
    end

    @two.deleted = true
    assert_equal(0, @two.hours)
  end

  test "points" do
    [@one, @two, @three, @four].each do |s|
      assert_equal(s.points, 1)
    end

    @two.deleted = true
    assert_equal(0, @two.points)
  end

  test 'no_overlap_with_standbys' do
    sb = Standby.new(:start_time => Date.today + 7.hours,
                     :end_time => Date.today + 11.hours)
    @m1.standbys << sb

    si = SleepIn.new(:date => Date.today - 1.day, :unit => 'Engine')
    si.member = @m1
    assert(si.save, si.errors.inspect)
    
    sb.destroy
    sb = Standby.new(:start_time => Date.today + 7.hours,
                     :end_time => Date.today + 19.hours)
    @m1.standbys << sb
    
    si.destroy
    si = SleepIn.new(:date => Date.today, :unit => 'Engine')
    si.member = @m1
    assert(si.save, si.errors.inspect)

    sb.destroy
    sb = Standby.new(:start_time => Date.today + 6.hours,
                     :end_time => Date.today + 12.hours)
    @m1.standbys << sb

    si.destroy
    si = SleepIn.new(:date => Date.today - 1.day, :unit => 'Engine')
    si.member = @m1
    assert(!si.save)

    sb.deleted = true
    assert(sb.save)
    assert(si.save)
  end

  test 'oldest' do
    assert_equal(2009, SleepIn.oldest.date.year)
    si = SleepIn.new(:date => Date.parse('2007-04-25'),
                     :unit => 'Engine',
                     :member_id => @m1.id)
    assert(si.save)
    assert_equal(si, SleepIn.oldest)
  end
end
