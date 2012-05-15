class AddSoldToFeaturedItems < ActiveRecord::Migration
  def self.up
    add_column :featured_items ,:sold,:boolean ,:default => false
  end

  def self.down
    remove_column :featured_items ,:sold
  end
end
