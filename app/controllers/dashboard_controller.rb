require 'entry_lister'
class DashboardController < ApplicationController
  before_action :require_user
  before_action :get_folders, :only  => [:index, :feeds, :settings]

  def index
  end

  def feeds
    render :layout => nil
  end

  def entries
    redirect_to dashboard_index_path and return unless request.xhr?
    @lister = EntryLister.new(current_user, params[:type], params[:filter], params[:id])
    @lister.generate
    render :layout => nil
  end

  def settings
    @users = User.all
  end

  private ######################################################################

  def get_folders
    @folders = current_user.folders.order(:position)
  end

end
