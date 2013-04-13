require 'entry_lister'
class EntriesController < ApplicationController
  def show
    @lister = EntryLister.new(current_user, params[:type], params[:filter], params[:id], params[:page])
    @lister.generate
    if mobile_device?
      prev_entry_url = entry_with_options_path(@lister.identifier, @lister.filter, @lister.type, @lister.page-1) if @lister.prev
      next_entry_url = entry_with_options_path(@lister.identifier, @lister.filter, @lister.type, @lister.page+1) if @lister.next
      @page_data_attributes = { :prev => prev_entry_url, :next => next_entry_url }
    else
      render :layout => nil
    end
  end

  def update
    @entry = current_user.entries.find(params[:id])
    if @entry.update(entry_params)
      render :json => { :status => 'success' }
    else
      render :json => { :status => 'error', :errors => @entry.errors }, :status => :unprocessable_entity
    end
  end

  private ######################################################################

  def entry_params
    params.require(:entry).permit(:read, :starred)
  end
end
