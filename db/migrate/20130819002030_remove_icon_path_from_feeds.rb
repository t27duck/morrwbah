class RemoveIconPathFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :icon_path
  end
end
