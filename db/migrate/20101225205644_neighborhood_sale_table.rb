class NeighborhoodSaleTable < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods_sales, :id => false do |t|
      t.integer :neighborhood_id
      t.integer :sale_id
    end
  end

  def self.down
    drop_table :neighborhoods_sales
  end
end
