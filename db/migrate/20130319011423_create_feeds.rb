class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.string :url
      t.string :feed_url, :null => false
      t.string :etag
      t.datetime :last_modified, :null => false
      t.boolean :sanitize, :null => false, :default => true

      t.timestamps
    end

    add_index :feeds, :user_id
  end
end
