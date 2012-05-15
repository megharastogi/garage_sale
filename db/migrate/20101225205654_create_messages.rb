class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :category
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
