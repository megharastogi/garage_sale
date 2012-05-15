class AddUserIdToSale < ActiveRecord::Migration
  def self.up
    add_column :sales ,:user_id, :integer
    add_column :sales ,:transaction_id, :integer
  end

  def self.down
    remove_column :sales ,:user_id
    remove_column :sales ,:transaction_id
  end
end
