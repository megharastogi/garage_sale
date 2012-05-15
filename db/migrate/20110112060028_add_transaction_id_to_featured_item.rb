class AddTransactionIdToFeaturedItem < ActiveRecord::Migration
  def self.up
    add_column :featured_items , :transaction_id , :string
  end

  def self.down
    remove_column :featured_items , :transaction_id 
  end
end
