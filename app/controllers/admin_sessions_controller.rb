class AdminSessionsController < ApplicationController
  expose(:admin_session)

  def new
    if current_admin
      redirect_to(admin_console_path)
    end
  end

  def create
    respond_to do |format|
      if admin_session.save
        format.html { redirect_to(admin_console_path) }
        format.xml { render :xml => admin_session, :status => :created, :location => admin_session }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => admin_session.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if current_admin
      admin_session.destroy
    end
    
    redirect_to(login_path)
  end
  
end
