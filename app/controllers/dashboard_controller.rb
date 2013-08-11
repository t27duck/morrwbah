require 'entry_lister'
class DashboardController < ApplicationController
  before_action :require_user
  before_action :get_folders, :only  => [:index, :feeds, :settings]

  def index
    params[:type] ||= "all"
    params[:filter] ||= "unread"
    @lister = EntryLister.new(current_user, params[:type], params[:filter], params[:feed_id])
    @lister.generate
  end

  def feeds
    render :layout => nil
  end

  def entries
    params[:type] ||= "all"
    params[:filter] ||= "unread"
    @lister = EntryLister.new(current_user, params[:type], params[:filter], params[:id])
    @lister.generate
  end

  def settings
    @users = User.all
  end

  private ######################################################################

  def get_folders
    @folders = current_user.folders.order(:position)
  end

end
