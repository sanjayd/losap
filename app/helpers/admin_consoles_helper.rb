module AdminConsolesHelper
  def options_for_locked_months(locked_months)
    options_for_select(locked_months.map do |month|
      [month.month.strftime("%b %Y"), month.id]
    end)
  end
end
