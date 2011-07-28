class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  helper_method :current_admin

  after_filter :flash_to_headers

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

  def flash_to_headers
    return unless request.xhr?
    [:notice, :warning].each do |f|
      unless flash[f].blank?
        response.headers["X-Flash#{f.to_s.camelize}"] = flash[f]
      end
    end
  end
end

