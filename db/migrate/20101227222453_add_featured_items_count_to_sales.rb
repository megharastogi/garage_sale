class AddFeaturedItemsCountToSales < ActiveRecord::Migration
  def self.up
    add_column :sales, :featured_items_count, :integer, :default=> 0
  end

  def self.down
    remove_column :sales, :featured_items_count
  end
end

