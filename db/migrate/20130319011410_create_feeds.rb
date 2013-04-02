class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :user_id, :null => false
      t.integer :position, :null => false, :default => 0
      t.integer :folder_id, :null => false
      t.string :title, :null => false
      t.string :url
      t.string :feed_url, :null => false
      t.string :etag
      t.string :icon_path
      t.boolean :sanitize, :null => false, :default => true
      t.datetime :last_modified, :null => false
      t.datetime :last_checked

      t.timestamps
    end
    
    add_index :feeds, :folder_id
    add_index :feeds, :user_id
  end
end
