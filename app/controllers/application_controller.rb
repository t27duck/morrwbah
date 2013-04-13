class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :use_mobile_views_if_applicable
  before_action :require_user
  
  private ######################################################################
   
  def use_mobile_views_if_applicable
    prepend_view_path Rails.root + 'app' + 'views_mobile' if mobile_device?
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      # Season this regexp to taste. I prefer to treat iPad as non-mobile.
      (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end
 
  def require_user
    redirect_to login_path, :notice => "You must be logged in" unless current_user
  end

  def current_user
    #return User.first
    @current_user ||= User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token]
  end
  helper_method :current_user
end
