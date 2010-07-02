class AdminConsolesController < ApplicationController
  def show
    redirect_to(login_path) unless current_admin
    @locked_month = LockedMonth.new
    @all_months = LockedMonth.months
    @locked_months = LockedMonth.locked_months
    @unlocked_months = LockedMonth.unlocked_months
    @members = Member.all
  end
end
