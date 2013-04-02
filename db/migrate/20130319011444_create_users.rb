class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false
      t.string :password_digest, :null => false
      t.string :auth_token, :null => false

      t.timestamps
    end

    add_index :users, :login, :unique => true
    add_index :users, :auth_token, :unique => true

    User.create!(:login => 'user', :password => '12345', :password_confirmation => '12345')
  end
end
