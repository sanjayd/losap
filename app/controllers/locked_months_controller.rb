class LockedMonthsController < ApplicationController
  load_and_authorize_resource

  expose(:locked_month)

  def create
    respond_to do |format|
      if locked_month.save
        flash[:notice] = "Month Successfully Locked"
      else
        flash[:warning] = 'Month is Already Locked'
      end
      format.html {redirect_to admin_console_path}
    end
  end

  def destroy
    respond_to do |format|
      if locked_month
        locked_month.destroy
        flash[:notice] = "Month Successfully Unlocked"
      else
        flash[:warning] = 'Month is Already Unlocked'
      end
      format.html {redirect_to admin_console_path}
    end
  end
end
