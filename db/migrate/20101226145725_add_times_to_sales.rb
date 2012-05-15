class AddTimesToSales < ActiveRecord::Migration
  def self.up
    add_column :sales, :time_from, :time
    add_column :sales, :time_to, :time
  end

  def self.down
    remove_column :sales, :time_to
    remove_column :sales, :time_from
  end
end
