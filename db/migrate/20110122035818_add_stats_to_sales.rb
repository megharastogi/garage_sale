class AddStatsToSales < ActiveRecord::Migration
  def self.up
    add_column :sales , :stats, :boolean,:default => false
    add_column :sales , :transaction_id, :string
    
  end

  def self.down
    remove_column :sales,:stats
    remove_column :sales , :transaction_id
  end
end
