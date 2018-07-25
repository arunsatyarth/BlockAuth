class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
        t.string :address , :null=>false, unique: true
        t.string :username , :null=>false, unique: true
        t.string :name 
        t.string 	:profilepic


        t.string 'password_digest'
        t.string 'remember_digest'#this is to maintain login session through reboots
        

      t.timestamps
    end
  end
end
