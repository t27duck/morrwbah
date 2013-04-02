class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.integer :user_id, :null => false
      t.integer :position, :null => false, :default => 0
      t.string :name, :null => false

      t.timestamps
    end

    add_index :folders, :user_id
    add_index :folders, :position

  end
end
