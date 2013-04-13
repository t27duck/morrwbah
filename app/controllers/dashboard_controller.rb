require 'entry_lister'
class DashboardController < ApplicationController
  before_action :require_user
  before_action :get_folders, :only  => [:index, :feeds, :settings]

  def index
  end

  def feeds
    render :layout => nil unless mobile_device?
  end

  def entries
    @lister = EntryLister.new(current_user, params[:type], params[:filter], params[:id])
    @lister.generate
    render :layout => nil unless mobile_device?
  end

  def settings
    @users = User.all
  end

  private ######################################################################

  def get_folders
    @folders = current_user.folders.order(:position)
  end

end
