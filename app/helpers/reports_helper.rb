module ReportsHelper
  def format_month(month)
    month.strftime("%B %Y")
  end

  def total_points(member)
    points = member.sleep_in_points(:year => @report.year) +
      member.standby_points(:year => @report.year)
    (points > 20) ? 20 : points
  end
  
  def filter_standbys(member)
    member.standbys.by_year(@report.year).find_all {|sb| sb.points > 0}
  end
  
  def filter_sleep_ins(member)
    member.sleep_ins.by_year(@report.year).find_all {|si| si.points > 0}
  end
end
