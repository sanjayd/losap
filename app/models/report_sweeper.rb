class ReportSweeper < ActionController::Caching::Sweeper
  observe SleepIn, Standby
  
  def expire_cached_report(s)
    month = case s
    when SleepIn then s.date.beginning_of_month
    when Standby then s.start_time.beginning_of_month.to_date
    else nil
    end
    
    expire_fragment("report_#{month}")
    expire_fragment("report_#{month.year}")
  end
  
  alias_method :after_save, :expire_cached_report
  alias_method :after_destroy, :expire_cached_report
end