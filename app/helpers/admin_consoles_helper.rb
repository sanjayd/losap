module AdminConsolesHelper
  def options_for_locked_months(locked_months)
    options_for_months(locked_months.map {|month| month.month})
  end
end
