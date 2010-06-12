module ReportsHelper
  def format_month(month)
    month.strftime("%B %Y")
  end

  def oldest_month
    [SleepIn.oldest.date, Standby.oldest.date].min.beginning_of_month
  end

  def options_for_past_months
    months = []
    
    (1 .. 24).each do |num_months|
      month = Date.today.beginning_of_month - num_months.months
      break if oldest_month > month
      months << month
    end
    
    options_for_months(months)
  end
end
