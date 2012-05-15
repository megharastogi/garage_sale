class AddViewCountToSales < ActiveRecord::Migration
  def self.up
    add_column :sales, :sale_views_count, :integer, :default=>0
  end

  def self.down
    remove_column :sales, :sale_views_count
  end
end

