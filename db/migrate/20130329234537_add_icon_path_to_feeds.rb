class AddIconPathToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :icon_path, :string
  end
end
