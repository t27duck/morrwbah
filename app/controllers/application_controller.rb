class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_user
  
  private ######################################################################

  def require_user
    redirect_to login_path, :notice => "You must be logged in" unless current_user
  end

  def current_user
    #return User.first
    @current_user ||= User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token]
  end
  helper_method :current_user
end
