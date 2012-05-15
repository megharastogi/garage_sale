class ChangeTransactionIdType < ActiveRecord::Migration
  def self.up
    remove_column :sales , :transaction_id
    add_column :sales , :transaction_id , :string
  end

  def self.down
    remove_column :sales , :transaction_id
    add_column :sales , :transaction_id , :integer
  end
end
