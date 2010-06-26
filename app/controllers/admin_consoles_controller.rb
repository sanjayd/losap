class AdminConsolesController < ApplicationController
  def show
    redirect_to(login_path) unless current_admin
    @locked_month = LockedMonth.new
    @all_months = LockedMonth.last_six_months
    @locked_months = LockedMonth.locked_in_last_six_months
    @unlocked_months = LockedMonth.unlocked_in_last_six_months
    @members = Member.all(:order => 'lastname ASC, firstname ASC, badgeno ASC')
  end
end
