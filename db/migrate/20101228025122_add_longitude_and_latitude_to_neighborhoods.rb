class AddLongitudeAndLatitudeToNeighborhoods < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, :longitude, :float
    add_column :neighborhoods, :latitude, :float
  end

  def self.down
    remove_column :neighborhoods, :latitude
    remove_column :neighborhoods, :longitude
  end
end

