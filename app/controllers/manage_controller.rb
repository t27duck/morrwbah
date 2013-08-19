class ManageController < ApplicationController

  def index
    @users = User.all
    @feeds = current_user.feeds
  end

end
