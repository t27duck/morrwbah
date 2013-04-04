class EntriesController < ApplicationController
  before_action :set_feed_and_entry, :except => [:fetch]

  def show
    render :layout => nil
  end

  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { render :text => 'success' }
        format.json { head :no_content }
      else
        format.html { render text: @entry.errors, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def fetch
    @lister = EntryLister.new(current_user, params[:type], params[:filter], params[:id])
    @lister.generate
    
    render :layout => nil
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
