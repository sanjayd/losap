class ReportSweeper < ActionController::Caching::Sweeper
  observe SleepIn, Standby
  
  def expire_cached_report(s)
    month = case s
    when SleepIn then s.date.beginning_of_month
    when Standby then s.start_time.beginning_of_month.to_date
    else nil
    end
    
    expire_fragment :controller => "reports", :action => "show", :date => month
    expire_fragment :controller => "reports", :action => "show", :date => month.year
  end
  
  alias_method :after_save, :expire_cached_report
  alias_method :after_destroy, :expire_cached_report
end