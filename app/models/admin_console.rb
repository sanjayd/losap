class AdminConsole
  def initialize(page=nil)
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
    @members ||= Member.order('lastname asc, firstname asc, badgeno asc')\
                       .paginate(:page => @page)
  end

  def admins
    @admins ||= Admin.all
  end
    
  def years
    @years ||= (1 .. 3).to_a.map {|i| Date.today.beginning_of_year.year - i}
  end
end