class AdminConsolesController < ApplicationController
  def show
    @locked_month = LockedMonth.new
    @locked_months = LockedMonth.last_two_years
  end
end
