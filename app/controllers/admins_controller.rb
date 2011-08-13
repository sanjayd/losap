class AdminsController < ApplicationController
  load_and_authorize_resource

  expose(:admin)
  
  def new
  end
  
  def create
    respond_to do |format|
      if admin.save
        flash[:notice] = 'Registered New Admin'
        format.html { redirect_to(admin_console_path) }
        format.xml { render :xml => admin, :status => :created, :location => admin }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end
  
  def update
    respond_to do |format|
      if !current_admin.valid_password? params[:old_password]
        flash[:warning] = 'Current password is incorrect'
        format.html { render :action => "edit" }
      elsif admin.update_attributes(params[:admin])
        flash[:notice] = "Password Changed"
        format.html { redirect_to(admin_console_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    admin.destroy
    
    respond_to do |format|
      flash[:notice] = "Admin deleted"
      format.html { redirect_to(admin_console_path) }
    end
  end
end
