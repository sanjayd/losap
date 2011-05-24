class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  helper_method :current_admin

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    if current_admin
      redirect_to(admin_console_path)
    else
      redirect_to(login_path)
    end
  end

  private
  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end

  def current_admin
    @current_admin = current_admin_session && current_admin_session.record
  end

  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end
end

