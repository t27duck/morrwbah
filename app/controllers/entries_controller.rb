class EntriesController < ApplicationController
  before_action :set_feed
  before_action :set_entry, only: [:show, :edit, :update, :destroy]

  def show
    @entries = @feed.entries
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

  def set_feed
    @feed = Feed.find(params[:id])
  end

end
