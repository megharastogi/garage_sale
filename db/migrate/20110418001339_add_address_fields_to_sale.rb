class AddAddressFieldsToSale < ActiveRecord::Migration
  def self.up
    add_column :sales, :street, :string
    add_column :sales, :zipcode, :string
  end

  def self.down
    remove_column :sales, :zipcode
    remove_column :sales, :street
  end
end
