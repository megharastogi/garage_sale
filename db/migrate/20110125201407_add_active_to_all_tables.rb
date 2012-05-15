class AddActiveToAllTables < ActiveRecord::Migration
  def self.up
    add_column :sales , :active, :boolean,:default => true
    add_column :cities , :active, :boolean,:default => true
    add_column :states , :active, :boolean,:default => true
    add_column :neighborhoods , :active, :boolean,:default => true
    add_column :featured_items , :active, :boolean,:default => true
    add_column :categories , :active, :boolean,:default => true
  end

  def self.down
    remove_column :sales , :active
    remove_column :cities , :active
    remove_column :states , :active
    remove_column :neighborhoods , :active
    remove_column :featured_items , :active
    remove_column :categories , :active
  end
end
