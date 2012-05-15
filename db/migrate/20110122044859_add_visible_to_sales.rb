class AddVisibleToSales < ActiveRecord::Migration
  def self.up
    add_column :sales , :visible, :boolean,:default => false
  end

  def self.down
    remove_column :sales , :visible
  end
end
