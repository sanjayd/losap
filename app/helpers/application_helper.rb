module ApplicationHelper
  def options_for_months(months)
    options_for_select(months.map do |month|
      [month.strftime("%b %Y"), month]
    end)
  end

  def submit_link(name)
    link_to name, '#', :class => "submit"
  end
end

