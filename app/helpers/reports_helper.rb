module ReportsHelper
  def format_month(month)
    month.strftime("%B %Y")
  end

  def total_points(member)
    points = member.sleep_in_points(:year => @year) +
      member.standby_points(:year => @year)
    (points > 20) ? 20 : points
  end
end
