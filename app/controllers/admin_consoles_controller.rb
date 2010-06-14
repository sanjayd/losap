class AdminConsolesController < ApplicationController
  def show
    @locked_month = LockedMonth.new
    @all_months = LockedMonth.last_six_months
    @locked_months = LockedMonth.locked_in_last_six_months
    @unlocked_months = LockedMonth.unlocked_in_last_six_months
  end
end
