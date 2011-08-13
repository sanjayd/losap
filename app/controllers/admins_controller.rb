class AdminsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :xml

  expose(:admin)
  
  def new
  end
  
  def create
    flash[:notice] = 'Registered New Admin' if admin.save
    respond_with admin, location: admin_console_path
  end

  def edit
  end
  
  def update
    respond_to do |format|
      if !current_admin.valid_password? params[:old_password]
        flash.now[:warning] = 'Current password is incorrect'
        format.html { render action: "edit" }
      elsif admin.update_attributes(params[:admin])
        format.html { redirect_to(admin_console_path, notice: "Password Changed") }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
  def destroy
    admin.destroy
    flash[:notice] = 'Admin deleted'
    respond_with(admin, location: admin_console_path)
  end
end
