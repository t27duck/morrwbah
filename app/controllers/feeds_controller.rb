class FeedsController < ApplicationController
  before_action :set_feed, only: [:edit, :update, :destroy, :fetch]
  before_action :require_user

  def index
    @feeds = current_user.feeds
    render :layout => nil
  end

  def show
    if params[:id].to_s == '0'
      @entries = current_user.entries.order(:published => :desc).unread.page(params[:page]).per_page(5)
    else
      @feed = current_user.feeds.find(params[:id])
      @entries = @feed.entries.order(:published => :desc).unread.page(params[:page]).per_page(5)
    end
    render :layout => nil
  end

  def new
    @feed = current_user.feeds.new
  end

  def edit
  end

  def create
    @feed = current_user.feeds.new(feed_params)
    @feed.set_info!

    respond_to do |format|
      if @feed.save
        @feed.create_new_entries!
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feed }
      else
        format.html { render action: 'new' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
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
    params.require(:feed).permit(:title, :url, :feed_url, :sanitize)
  end
end
