class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :sex
      t.string :street
      t.string :city
      t.string :zipcode
      t.string :state
      t.string :salt
      t.string :hashed_password
      t.string :account_type , :default=> 'user'
      t.string :email
      t.string :activation_code
      t.integer :active, :default=>0
      t.string :forgot_password_code
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
