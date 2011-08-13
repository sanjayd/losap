class AdminSessionsController < ApplicationController
  expose(:admin_session)

  respond_to :html, :xml

  def new
    if current_admin
      redirect_to(admin_console_path)
    end
  end

  def create
    admin_session.save
    respond_with admin_session, location: admin_console_path
  end
  
  def destroy
    if current_admin
      admin_session.destroy
    end
    redirect_to(login_path)
  end
end
