class AdminSessionsController < ApplicationController
  def new
    @admin_session = AdminSession.new
  end

  def create
    @admin_session = AdminSession.new(params[:admin_session])
    
    respond_to do |wants|
      if @admin_session.save
        flash[:notice] = 'Logged In'
        wants.html { redirect_to(admin_console_path) }
        wants.xml { render :xml => @admin_session, :status => :created, :location => @admin_session }
      else
        wants.html { render :action => "new" }
        wants.xml { render :xml => @admin_session.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @admin_session = AdminSession.find
    @admin_session.destroy
    flash[:notice] = "Logged Out"
    redirect_to(login_path)
  end
  
end
