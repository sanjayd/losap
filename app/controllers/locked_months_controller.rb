class LockedMonthsController < ApplicationController
  def create
    @locked_month = LockedMonth.new(params[:locked_month])
    
    respond_to do |format|
      if @locked_month.save
        flash[:notice] = "Month Successfully Locked"
      else
        flash[:warning] = 'Month is Already Locked'
      end
      format.html {redirect_to admin_console_path}
    end
  end

  def destroy
    @locked_month = LockedMonth.find(params[:id])
    
    respond_to do |format|
      if @locked_month
        @locked_month.destroy
        flash[:notice] = "Month Successfully Unlocked"
      else
        flash[:warning] = 'Month is Already Unlocked'
      end
      format.html {redirect_to admin_console_path}
    end
  end
end
