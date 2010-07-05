class AdminConsole
  def initialize(page)
    @page = page || 1
  end
  
  def locked_month
    @locked_month ||= LockedMonth.new
  end
  
  def all_months
    @all_months ||= LockedMonth.months
  end
  
  def locked_months
    @locked_months ||= LockedMonth.locked_months
  end
  
  def unlocked_months
    @unlocked_months ||= LockedMonth.unlocked_months
  end
  
  def members
    @members ||= Member.paginate(:page => @page, 
      :order => "lastname ASC, firstname ASC, badgeno ASC")
  end  
end