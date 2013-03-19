class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :feed_id, :null => false
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.string :url, :null => false
      t.string :author, :null => false
      t.text :summary
      t.text :content
      t.datetime :published, :null => false
      t.boolean :read, :null => false, :default => false
      t.boolean :starred, :null => false, :default => false

      t.timestamps
    end

    add_index :entries, :feed_id
    add_index :entries, :user_id
  end
end
