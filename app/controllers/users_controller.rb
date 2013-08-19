class UsersController < ApplicationController
  before_action :set_user, :only => [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to manage_index_path, :notice => "User created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update_attributes(user_params)
      redirect_to manage_index_path, :notice => "User updated"
    else
      render 'new'
    end
  end

  def destroy
    @user.destroy
    redirect_to manage_index_path, :notice => "User deleted"
  end

  private ######################################################################

  def set_user
    @user = User.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation)
  end
  
end
