module ReportsHelper
  def format_month(month)
    month.strftime("%B %Y")
  end

  def total_points(report, member)
    points = report.sleep_in_points(member) +
      report.standby_points(member)
    (points > 20) ? 20 : points
  end
  
  def filter_standbys(report, member)
    report.standbys_for_member(member).find_all {|sb| sb.points > 0}
  end
  
  def filter_sleep_ins(report, member)
    report.sleep_ins_for_member(member).find_all {|si| si.points > 0}
  end
end
