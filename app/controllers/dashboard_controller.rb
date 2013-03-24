class DashboardController < ApplicationController
  before_filter :require_user

  def index
    @feeds = current_user.feeds
  end
end
