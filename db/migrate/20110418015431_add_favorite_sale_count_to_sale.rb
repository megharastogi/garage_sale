class AddFavoriteSaleCountToSale < ActiveRecord::Migration
  def self.up
    add_column :sales, :favorite_sale_count, :integer, :default=>0
  end

  def self.down
    remove_column :sales, :favorite_sale_count
  end
end
