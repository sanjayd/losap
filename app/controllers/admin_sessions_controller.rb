class AdminSessionsController < ApplicationController
  def new
    if current_admin
      redirect_to(admin_console_path)
    end
    
    @admin_session = AdminSession.new
  end

  def create
    @admin_session = AdminSession.new(params[:admin_session])
    
    respond_to do |wants|
      if @admin_session.save
        wants.html { redirect_to(admin_console_path) }
        wants.xml { render :xml => @admin_session, :status => :created, :location => @admin_session }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @admin_session.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if current_admin
      @admin_session = AdminSession.find
      @admin_session.destroy
    end
    
    redirect_to(login_path)
  end
  
end
