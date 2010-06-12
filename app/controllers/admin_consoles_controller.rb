class AdminConsolesController < ApplicationController
  def show
    @locked_month = LockedMonth.new
    @locked_months = LockedMonth.last_two_years
    @unlocked_months = LockedMonth.unlocked_in_last_two_years
  end
end
