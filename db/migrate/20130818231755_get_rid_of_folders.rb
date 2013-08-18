class GetRidOfFolders < ActiveRecord::Migration
  def change
    remove_index :feeds, :folder_id
    remove_column :feeds, :folder_id
    remove_index :folders, :user_id
    remove_index :folders, :position
    drop_table :folders
  end
end
