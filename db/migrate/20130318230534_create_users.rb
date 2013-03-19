class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false
      t.string :password_digest, :null => false
      t.string :auth_token, :null => false

      t.timestamps
    end

    add_index :users, :login, :uniq => true
    add_index :users, :auth_token, :uniq => true
  end
end
