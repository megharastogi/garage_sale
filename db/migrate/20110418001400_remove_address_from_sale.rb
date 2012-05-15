class RemoveAddressFromSale < ActiveRecord::Migration
  def self.up
      remove_column :sales, :address
  end

  def self.down
    add_column :sales, :address, :text
  end
end
