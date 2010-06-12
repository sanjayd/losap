module ReportsHelper
  def format_month(month)
    month.strftime("%B %Y")
  end
end
