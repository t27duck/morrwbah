require 'entry_lister'
class FeedsController < ApplicationController
  before_action :fetch_entries, only: [:index, :show]
  before_action :set_feed, only: [:edit, :update, :destroy]

  def index
  end

  def show
    render :index
  end

  def new
    @feed = current_user.feeds.new
  end

  def edit
  end

  def create
    @feed = current_user.feeds.new(feed_params)
    if @feed.save
      redirect_to manage_index_path, notice: 'Feed was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @feed.update(feed_params)
      redirect_to manage_index_path, notice: 'Feed was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @feed.destroy
    flash[:notice] = "Feed deleted"
    redirect_to manage_index_path
  end

  def fetch
    current_user.fetch_feeds!
    redirect_to root_path
  end

  private ######################################################################

  def set_feed
    @feed = current_user.feeds.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:title, :feed_url, :sanitization_level)
  end
  
  def fetch_entries
    params[:id] ||= "all"
    params[:filter] ||= "unread"
    @lister = EntryLister.new(current_user, params[:filter], params[:id])
    @lister.generate
  end
end
