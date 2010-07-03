class AdminConsolesController < ApplicationController
  def show
    unless current_admin
      redirect_to(login_path)
      return
    end
    
    @locked_month = LockedMonth.new
    @all_months = LockedMonth.months
    @locked_months = LockedMonth.locked_months
    @unlocked_months = LockedMonth.unlocked_months
    @members = Member.paginate(:page => params[:page], 
      :order => "lastname ASC, firstname ASC, badgeno ASC")
  end
end
