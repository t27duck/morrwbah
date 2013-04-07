class EntriesController < ApplicationController
  before_action :set_feed_and_entry, :except => [:fetch]

  def show
    render :layout => nil
  end

  def update
    if @entry.update(entry_params)
      render :json => { :status => 'success' }
    else
      render :json => { :status => 'error', :errors => @entry.errors }, :status => :unprocessable_entity
    end
  end

  private ######################################################################

  def set_feed_and_entry
    @feed = Feed.find(params[:feed_id])
    @entry = @feed.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:read, :starred)
  end
end
