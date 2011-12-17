require "test_helper"

class ReportTest < ActiveSupport::TestCase
  test "creation" do
    report = Report.new('2009')
    assert(report.annual?, "Report not identified as annual")
    assert(!report.monthly?, "Report impropertly identified as monthly")
    assert_equal(Date.parse('2009-1-1'), report.year)
    assert_equal(Member.order('lastname asc').order('firstname asc').order('badgeno asc').all,
                 report.members)
    
    report = Report.new('2009-05-01')
    assert(report.monthly?, "Report not idenfied as monthly")
    assert(!report.annual?, "Report improperly identified as annual")
    assert_equal(Date.parse('2009-05-01'), report.month)
    assert_equal(Member.order('badgeno asc').all, report.members)
  end
  
end