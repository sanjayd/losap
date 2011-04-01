class MemberSweeper < ActionController::Caching::Sweeper
  observe SleepIn, Standby
  
  def expire_cached_entry(s)
    month = if s.is_a? SleepIn
      s.date.beginning_of_month
    else
      s.start_time.to_date.beginning_of_month
    end
  
    [month, month.year].each do |fragment|
      expire_fragment :controller => "members",
                      :action => "show",
                      :id => s.member.id,
                      :fragment => fragment
    end  
  end
  
  alias_method :after_save, :expire_cached_entry
  alias_method :after_destroy, :expire_cached_entry
end