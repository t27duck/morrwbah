class EntriesController < ApplicationController
  before_action :set_feed_and_entry, :except => :index

  def index
    redirect_to dashboard_index_path
  end

  def show
    @entry.update_attributes!(:read => true) if params[:mark_read]
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
    @entry = current_user.entries.find(params[:id])
    @feed = @entry.feed
  end

  def entry_params
    params.require(:entry).permit(:read, :starred)
  end
end
