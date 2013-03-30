class AddFolderIdToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :position, :integer, :null => false, :default => 0
    add_column :feeds, :folder_id, :integer
    add_index :feeds, :folder_id

    Feed.update_all(:folder_id => Folder.first.id)

    change_column :feeds, :folder_id, :integer, :null => false
  end
end
