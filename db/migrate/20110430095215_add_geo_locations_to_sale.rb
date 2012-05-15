class AddGeoLocationsToSale < ActiveRecord::Migration
  def self.up
    add_column :sales, :longitude, :string
    add_column :sales, :latitude, :string
  end

  def self.down
    remove_column :sales, :latitude
    remove_column :sales, :longitude
  end
end
