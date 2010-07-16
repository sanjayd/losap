class AdminsController < ApplicationController
  load_and_authorize_resource
  
  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(params[:admin])
    
    respond_to do |wants|
      if @admin.save
        flash[:notice] = 'Registered New Admin'
        wants.html { redirect_to(admin_console_path) }
        wants.xml { render :xml => @admin, :status => :created, :location => @admin }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @admin = Admin.find(params[:id])
  end
  
  def update
    @admin = Admin.find(params[:id])
    
    respond_to do |wants|
      if !current_admin.valid_password? params[:old_password]
        flash[:warning] = 'Current password is incorrect'
        wants.html { render :action => "edit" }
      elsif @admin.update_attributes(params[:admin])
        flash[:notice] = "Password Changed"
        wants.html { redirect_to(admin_console_path) }
      else
        wants.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    
    respond_to do |wants|
      flash[:notice] = "Admin deleted"
      wants.html { redirect_to(admin_console_path) }
    end
  end
end
