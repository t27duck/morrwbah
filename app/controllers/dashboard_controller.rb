class DashboardController < ApplicationController
  before_filter :require_user

  def index
    @folders = current_user.folders.order(:position)
  end
end
