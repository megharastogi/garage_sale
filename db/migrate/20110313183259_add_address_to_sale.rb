class AddAddressToSale < ActiveRecord::Migration
  def self.up
    add_column :sales,:address ,:text
  end

  def self.down
    remove_column :sales,:address
  end
end
