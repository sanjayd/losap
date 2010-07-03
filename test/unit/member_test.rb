require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  def setup
    @one = members(:one)
    @two = members(:two)
  end

  test "require firstname" do
    @one.firstname = nil
    assert !@one.save
    assert_not_nil @one.errors['firstname']
  end

  test "require lastname" do
    @one.lastname = nil
    assert !@one.save
    assert_not_nil @one.errors['lastname']
  end

  test "require badgeno" do
    @one.badgeno = nil
    assert !@one.save
    assert_not_nil @one.errors['badgeno']
  end

  test "valid badgeno" do
    @one.badgeno = "bob"
    assert !@one.save
    assert_not_nil @one.errors['badgeno']
    
    @one.badgeno = "5.5"
    assert !@one.save
    assert_not_nil @one.errors['badgeno']
    
    @one.badgeno = "-1"
    assert !@one.save
    
    @one.badgeno = "1040423"
    assert !@one.save
    
    @one.badgeno = "1"
    @one.save
    assert @one.save
    
    @one.badgeno = "100"
    assert @one.save

    @one.badgeno = "503338"
    assert @one.save

    @one.badgeno = "999999"
    assert @one.save

    @one.badgeno = "DESH1"
    assert @one.save
    
    @one.badgeno = "DESH01"
    assert @one.save
    
    @one.badgeno = "DESH011"
    assert !@one.save

    @one.badgeno = @two.badgeno
    assert !@one.save
    assert_not_nil @one.errors['badgeno']
  end
     
  test "has_many_sleep_ins" do
    si = sleep_ins(:one)
    @one.sleep_ins << si
    assert_equal(si.member_id, @one.id)
    
    s = SleepIn.new(:date => si.date + 1.day, :unit => 'Truck')
    @one.sleep_ins << s
    s = SleepIn.new(:date => si.date - 1.day, :unit => 'Ambulance')
    @one.sleep_ins << s
    assert_equal(3, @one.sleep_ins.count)

    assert @one.sleep_ins[1].date > @one.sleep_ins[0].date
    assert @one.sleep_ins[2].date > @one.sleep_ins[1].date
  end

  test "has_many_stand_bys" do
    sb = standbys(:one)
    @one.standbys << sb
    assert_equal(sb.member_id, @one.id)

    s = Standby.new(:start_time => sb.start_time + 1.day,
                    :end_time => sb.end_time + 1.day)
    @one.standbys << s
    s = Standby.new(:start_time => sb.start_time - 1.day,
                    :end_time => sb.end_time - 1.day)
    @one.standbys << s
    assert_equal(3, @one.standbys.count)

    assert(@one.standbys[1].date > @one.standbys[0].date)
    assert(@one.standbys[2].date > @one.standbys[1].date)
  end

  test "hours" do
    month = sleep_ins(:one).date.beginning_of_month
    total_hours = [:one, :two].inject(0) do |hours, s|
      sl = sleep_ins(s)
      @one.sleep_ins << sl
      hours + sl.hours
    end

    assert(@one.save, @one.errors)
    assert_equal(total_hours, @one.hours(:month => month),
                 "#{total_hours} != #{@one.hours(:month => month)}")
    
    three = sleep_ins(:three)
    four = sleep_ins(:four)
    three.date = sleep_ins(:one).date - 1.month
    four.date = sleep_ins(:one).date + 1.month
    assert(three.save, three.errors)
    assert(four.save, four.errors)
    @one.sleep_ins << three
    @one.sleep_ins << four
    
    assert(@one.save, @one.errors)
    assert_equal(total_hours, @one.hours(:month => month),
                 "#{total_hours} != #{@one.hours(:month => month)}")   
    assert_equal(total_hours + three.hours + four.hours,
                 @one.hours(:year => month),
                 "#{total_hours + three.hours + four.hours} != !{#@one.hours(:year => month)}")

    three.date = month.end_of_month
    total_hours += three.hours
    assert(three.save)
    assert_equal(total_hours, @one.hours(:month => month),
                 "#{total_hours} != #{@one.hours(:month => month)}")
    assert_equal(total_hours + four.hours,
                 @one.hours(:year => month),
                 "#{total_hours + four.hours} != !{#@one.hours(:year => month)}")                 

    start_time = Time.local(2009, 8, 9, 15, 00, 00)
    end_time = start_time + 6.5.hours
    sb = Standby.new(:start_time => start_time, :end_time => end_time)
    total_hours += sb.hours
    @one.standbys << sb
    assert_equal(total_hours, @one.hours(:month => month),
                 "#{total_hours} != #{@one.hours(:month => month)}")  
    assert_equal(total_hours + four.hours, @one.hours(:year => month),
                 "#{total_hours + four.hours} != #{@one.hours(:year => month)}") 

    sb = Standby.new(:start_time => start_time + 1.month,
                        :end_time => end_time + 1.month)
    @one.standbys << sb
    assert_equal(total_hours, @one.hours(:month => month),
                 "#{total_hours} != #{@one.hours(:month => month)}")  
    assert_equal(total_hours + sb.hours + four.hours, @one.hours(:year => month),
                 "#{total_hours + sb.hours + four.hours} != #{@one.hours(:month => month)}")  
                 

    m = Member.new(:firstname => 'Brad', :lastname => 'Paisley', :badgeno => '135790')
    assert(m.save)
    assert_equal(0, m.hours(:month => Date.parse('2010-1-1')))
  end

  test "sleep_in_points" do
    month = Date.parse '2009-08-01'
    si = SleepIn.create(:date => '2009-08-01', :unit => 'Engine')
    @one.sleep_ins << si
    assert(@one.save, @one.errors.inspect)
    assert_equal(1,
                 @one.sleep_in_points(:month => month),
                 "1 != #{@one.sleep_in_points(:month => month)}")

    si = SleepIn.create(:date => '2009-08-02', :unit => 'Ambulance')
    @one.sleep_ins << si
    assert(@one.save, @one.errors.inspect)
    assert_equal(2,
                 @one.sleep_in_points(:month => month), 
                 "2 != #{@one.sleep_in_points(:month => month)}")

    si = SleepIn.create(:date => '2009-08-31', :unit => 'Truck')
    @one.sleep_ins << si
    assert(@one.save, @one.errors.inspect)
    assert_equal(3,
                 @one.sleep_in_points(:month => month),
                 "3 != #{@one.sleep_in_points(:month => month)}")
    
    si = SleepIn.create(:date => '2009-07-31', :unit => 'Engine')
    @one.sleep_ins << si
    assert(@one.save, @one.errors.inspect)
    assert_equal(3, 
                 @one.sleep_in_points(:month => month), 
                 "3 != #{@one.sleep_in_points(:month => month)}")
    assert_equal(4,
                 @one.sleep_in_points(:year => month),
                 "4 != #{@one.sleep_in_points(:year => month)}")

    si = SleepIn.create(:date => '2009-09-01', :unit => 'Engine')
    @one.sleep_ins << si
    assert(@one.save, @one.errors.inspect)
    assert_equal(3,
                 @one.sleep_in_points(:month => month), 
                 "3 != #{@one.sleep_in_points(:month => month)}")
    assert_equal(5,
                 @one.sleep_in_points(:year => month),
                 "5 != #{@one.sleep_in_points(:year => month)}")

    si = SleepIn.create(:date => '2008-12-31', :unit => 'Engine')
    @one.sleep_ins << si
    assert(@one.save, @one.errors.inspect)
    assert_equal(5,
                 @one.sleep_in_points(:year => month),
                 "5 != #{@one.sleep_in_points(:year => month)}")

    si = SleepIn.create(:date => '2010-1-1', :unit => 'Engine')
    @one.sleep_ins << si
    assert(@one.save, @one.errors.inspect)
    assert_equal(5,
                 @one.sleep_in_points(:year => month),
                 "5 != #{@one.sleep_in_points(:year => month)}")                 

    m = Member.new(:firstname => 'Bob', 
                   :lastname => 'Jones',
                   :badgeno => '123456')
    assert(m.save)

    assert_equal(0, m.sleep_in_points(:month => Date.parse('2010-1-1')))
    assert_equal(0, m.sleep_in_points(:year => Date.parse('2010-1-1')))
  end

  test "standby_points" do
    month = Date.parse '2009-08-01'
    start_time = Time.gm(2009, 8, 1, 15, 0, 0)
    end_time = start_time + 5.hours
    sb = Standby.new(:start_time => start_time, :end_time => end_time)
    @one.standbys << sb
    assert(@one.save, @one.errors.inspect)
    assert_equal(1,
                 @one.standby_points(:month => month), 
                 "1 != #{@one.standby_points(:month => month)}")

    sb = Standby.new(:start_time => start_time + 1.day,
                        :end_time => end_time + 1.day)
    @one.standbys << sb
    assert(@one.save, @one.errors.inspect)
    assert_equal(2,
                 @one.standby_points(:month => month),
                 "2 != #{@one.standby_points(:month => month)}")
    
    sb = Standby.new(:start_time => start_time - 1.month,
                        :end_time => end_time - 1.month)
    @one.standbys << sb
    assert(@one.save, @one.errors.inspect)
    assert_equal(2,
                 @one.standby_points(:month => month),
                 "2 != #{@one.standby_points(:month => month)}")
    assert_equal(3,
                 @one.standby_points(:year => month),
                 "3 != #{@one.standby_points(:year => month)}")

    sb = Standby.new(:start_time => start_time + 1.month,
                        :end_time => end_time + 1.month)
    @one.standbys << sb
    assert(@one.save, @one.errors.inspect)
    assert_equal(2,
                 @one.standby_points(:month => month),
                 "2 != #{@one.standby_points(:month => month)}")
    assert_equal(4,
                 @one.standby_points(:year => month),
                 "4 != #{@one.standby_points(:year => month)}")

    sb = Standby.new(:start_time => start_time.beginning_of_month + 4.hours,
                        :end_time => end_time.beginning_of_month + 9.hours)
    @one.standbys << sb
    assert(@one.save, @one.errors.inspect)
    assert_equal(3,
                 @one.standby_points(:month => month),
                 "3 != #{@one.standby_points(:month => month)}")
    
    sb = Standby.new(:start_time => start_time.end_of_month - 8.hours,
                        :end_time => end_time.end_of_month - 4.hours)
    @one.standbys << sb
    assert(@one.save, @one.errors.inspect)
    assert_equal(4,
                 @one.standby_points(:month => month),
                 "4 != #{@one.standby_points(:month => month)}")

    m = Member.new(:firstname => 'John', :lastname => 'Doe', :badgeno => '654321')
    assert(m.save)
    assert_equal(0, m.standby_points(:month => Date.parse('2010-1-1')))
  end

  test 'sleep_ins_and_standbys' do
    m = Member.new(:firstname => 'Bob', :lastname => 'Jones', :badgeno => '135791')
    assert(m.save)

    list = m.sleep_ins_and_standbys(:month => Date.parse('2010-01-01'))
    assert_equal(0, list.size)

    si1 = SleepIn.new(:date => Date.parse('2010-01-01'), :unit => 'Engine', :member_id => m.id)

    si2 = SleepIn.new(:date => Date.parse('2010-01-10'), :unit => 'Engine', :member_id => m.id)

    sb1 = Standby.new(:start_time => Time.parse('2010-01-05 07:00:00'),
                     :end_time => Time.parse('2010-01-05 12:00:00'),
                     :member_id => m.id)
    
    sb2 = Standby.new(:start_time => Time.parse('2010-01-15 07:00:00'),
                     :end_time => Time.parse('2010-01-15 12:00:00'),
                     :member_id => m.id)
    sb3 = Standby.new(:start_time => Time.parse('2010-01-10 07:00:00'),
                      :end_time => Time.parse('2010-01-10 15:00:00'),
                      :member_id => m.id)
                                                

    assert(si1.save)
    list = m.sleep_ins_and_standbys(:month => Date.parse('2010-01-01'))
    assert_equal(1, list.size)
    assert_equal(si1, list[0])

    assert(si2.save)
    list = m.sleep_ins_and_standbys(:month => Date.parse('2010-01-01'))
    assert_equal(2, list.size)
    assert_equal(si2, list[1])

    assert(sb1.save)
    list = m.sleep_ins_and_standbys(:month => Date.parse('2010-01-01'))
    assert_equal(3, list.size)
    assert_equal(sb1, list[1])

    assert(sb2.save)
    list = m.sleep_ins_and_standbys(:month => Date.parse('2010-01-01'))
    assert_equal(4, list.size)
    assert_equal(si1, list[0])
    assert_equal(sb1, list[1])
    assert_equal(si2, list[2])
    assert_equal(sb2, list[3])

    assert(sb3.save)
    list = m.sleep_ins_and_standbys(:month => Date.parse('2010-01-01'))
    assert_equal(5, list.size)
    assert_equal(si1, list[0])
    assert_equal(sb1, list[1])
    assert_equal(sb3, list[2])
    assert_equal(si2, list[3])
    assert_equal(sb2, list[4])
  end 

  test 'dependent_destroy' do
    m = Member.new(:firstname => "bob", 
      :lastname => "jones",
      :badgeno => "978568")
    assert(m.save)
    
    si = SleepIn.new(:date => Date.parse('2010-6-19'),
      :unit => "Engine",
      :member_id => m.id)
    assert(si.save)
    
    sb = Standby.new(:start_time => Time.local(2010, 6, 20, 7, 0, 0),
      :end_time => Time.local(2010, 6, 20, 15, 0, 0),
      :member_id => m.id)
    assert(sb.save)
    
    m.destroy
    assert_raise(ActiveRecord::RecordNotFound) {Member.find(m.id)}
    assert_raise(ActiveRecord::RecordNotFound) {SleepIn.find(si.id)}
    assert_raise(ActiveRecord::RecordNotFound) {Standby.find(sb.id)}
  end
end
