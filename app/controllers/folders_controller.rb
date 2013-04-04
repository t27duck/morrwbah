class FoldersController < ApplicationController
  
  # JSON request only
  def update_order
    Folder.transaction do
      folder_position = 1
      params[:folder_structure].each do |folder_group|
        folder_id = folder_group[:id]
        folder = current_user.folders.find(folder_id)
        folder.update_attributes!(:position => folder_position)
        folder_position += 1
        feed_position = 1
        folder_group[:children].each do |feed_item|
          feed = current_user.feeds.find(feed_item[:id])
          feed.update_attributes!(:folder_id => folder_id, :position => feed_position)
          feed_position += 1
        end
      end
    end
    render :json => {:status => 'ok'}
  end
end
