class LockedMonthsController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  expose(:locked_month)

  def create
    if locked_month.save
      flash[:notice] = "Month Successfully Locked"
    else
      flash[:warning] = 'Month is Already Locked'
    end
    redirect_to(admin_console_path)
  end

  def destroy
    if locked_month
      locked_month.destroy
      flash[:notice] = "Month Successfully Unlocked"
    else
      flash[:warning] = 'Month is Already Unlocked'
    end
    redirect_to(admin_console_path)
  end
end
