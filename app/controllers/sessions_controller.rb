class SessionsController < ApplicationController
  skip_before_action :require_user, :only => [:new, :create]

  def new
  end
  
  def create
    user = User.where(:login => params[:login]).first
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token  
      end
      redirect_to root_url
    else
      flash.now[:error] = "Invalid login or password"
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    @current_user = nil
    redirect_to login_url, :notice => "Logged out!"
  end
end
