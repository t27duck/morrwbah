class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :fetch]

  def index
    redirect_to settings_dashboard_index_path
  end

  def show
    redirect_to edit_feed_path(@feed)
  end

  def new
    @feed = current_user.feeds.new
  end

  def edit
  end

  def create
    @feed = current_user.feeds.new(feed_params)
    if @feed.save
      redirect_to settings_dashboard_index_path, notice: 'Feed was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @feed.update(feed_params)
      redirect_to settings_dashboard_index_path, notice: 'Feed was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @feed.destroy
    redirect_to settings_dashbaord_path
  end

  def fetch
    @feed.fetch!
    redirect_to feed_url(@feed)
  end

  private ######################################################################

  def set_feed
    @feed = Feed.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feed_params
    params.require(:feed).permit(:title, :feed_url, :sanitization_level, :folder_id)
  end
end
