class AdminConsolesController < ApplicationController
  def show
    @locked_month = LockedMonth.new
    @all_months = LockedMonth.last_two_years
    @locked_months = LockedMonth.locked_in_last_two_years
    @unlocked_months = LockedMonth.unlocked_in_last_two_years
  end
end
