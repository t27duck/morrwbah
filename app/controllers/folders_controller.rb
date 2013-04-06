class FoldersController < ApplicationController

  before_action :require_user
  before_action :set_folder, :only => [:show, :edit, :update, :destroy]

  def index
    @folders = current_user.folders.order(:position)
  end

  def show
    redirect_to edit_folder_path(@folder)
  end

  def new
    @folder = current_user.folders.new
  end

  def create
    @folder = current_user.folders.new(folder_params)
    if @folder.save
      redirect_to folders_path, :notice => "Folder created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @folder.update_attributes(folder_params)
      redirect_to folders_path, :notice => "Folder created"
    else
      render 'edit'
    end
  end

  def destroy
    @folder.destroy
    redirect_to folders_path, :notice => "Folder and subscriptions deleted"
  end

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
        if folder_group[:children]
          folder_group[:children].each do |feed_item|
            feed = current_user.feeds.find(feed_item[:id])
            feed.update_attributes!(:folder_id => folder_id, :position => feed_position)
            feed_position += 1
          end
        end
      end
    end
    render :json => {:status => 'ok'}
  end

  private ######################################################################

  def set_folder
    @folder = current_user.folders.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def folder_params
    params.require(:folder).permit(:name)
  end
end
