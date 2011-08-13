class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  expose(:current_admin_session) {AdminSession.find}  
  expose(:current_admin) {current_admin_session && current_admin_session.record}
  expose(:current_ability) {Ability.new(current_admin)}

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
  def flash_to_headers
    return unless request.xhr?
    [:notice, :warning].each do |f|
      unless flash[f].blank?
        response.headers["X-Flash#{f.to_s.camelize}"] = flash[f]
      end
    end
    
    flash.discard
  end

  def redirect_to(path)
    if request.xhr?
      render :update do |page|
        page.redirect_to(path)
      end
    else
      super
    end
  end
end

