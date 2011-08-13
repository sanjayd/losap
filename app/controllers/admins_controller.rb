class AdminsController < ApplicationController
  load_and_authorize_resource

  expose(:admin)
  
  def new
  end
  
  def create
    respond_to do |format|
      if admin.save
        format.html { redirect_to(admin_console_path, notice: 'Registered New Admin') }
        format.xml { render xml: admin, status: :created, location: admin }
      else
        format.html { render action: "new" }
        format.xml { render xml: admin.errors, status: :unprocessable_entity }
      end
    end
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
    
    respond_to do |format|
      format.html { redirect_to(admin_console_path, notice: "Admin deleted") }
    end
  end
end
