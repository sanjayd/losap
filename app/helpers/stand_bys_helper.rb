module StandBysHelper
  def format_time(time)
    time.strftime("%H%M")
  end

  def format_date_for_standby(date)
    date.strftime("%Y-%m-%d")
  end
end
