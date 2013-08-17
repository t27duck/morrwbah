require 'entry_lister'
class DashboardController < ApplicationController
  before_action :require_user

  def index
    fetch_entries
  end

  def feeds
    render :layout => nil
  end

  def entries
    fetch_entries
    render :index
  end

  def settings
    @users = User.all
  end

  private ######################################################################

  def fetch_entries
    params[:id] ||= "all"
    params[:filter] ||= "unread"
    @lister = EntryLister.new(current_user, params[:filter], params[:id])
    @lister.generate
  end

end
