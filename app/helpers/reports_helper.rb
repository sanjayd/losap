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
    standbys = member.standbys.by_year(@report.year)
    standbys.find_all {|sb| sb.points > 0}
  end
end
