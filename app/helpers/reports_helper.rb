module ReportsHelper
  def format_month(month)
    month.strftime("%B %Y")
  end

  def oldest_date
    [SleepIn.oldest.date, Standby.oldest.date].min
  end
end
