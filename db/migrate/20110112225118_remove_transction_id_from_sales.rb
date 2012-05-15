class RemoveTransctionIdFromSales < ActiveRecord::Migration
  def self.up
    remove_column :sales , :transaction_id 
  end

  def self.down
    add_column :sales , :transaction_id , :string
  end
end
