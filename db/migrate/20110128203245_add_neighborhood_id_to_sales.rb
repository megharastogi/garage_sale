class AddNeighborhoodIdToSales < ActiveRecord::Migration
  def self.up
    add_column :sales , :neighborhood_id,:integer
  end

  def self.down
    remove_column :sales , :neighborhood_id
  end
end
