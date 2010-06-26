class AdminsController < ApplicationController
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
  
end
