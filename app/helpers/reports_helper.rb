module ReportsHelper
  def format_month(month)
    month.strftime("%B %Y")
  end

  def total_points(member)
    points = member.sleep_in_points(:year => @year) +
      member.standby_points(:year => @year)
    (points > 20) ? 20 : points
  end
  
  def filter_standbys(member)
    standbys = member.standbys.find_by_year(@year)
    standbys.find_all {|sb| sb.points > 0}
  end
end
