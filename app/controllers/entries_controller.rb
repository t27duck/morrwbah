class EntriesController < ApplicationController
  before_action :set_feed_and_entry

  def show
    #@entry.update_attributes!(:read => true)
    render :layout => nil
  end

  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  private ######################################################################

  def set_feed_and_entry
    @feed = Feed.find(params[:feed_id])
    @entry = @feed.entries.find(params[:id])
  end

end
