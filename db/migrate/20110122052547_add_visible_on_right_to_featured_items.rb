class AddVisibleOnRightToFeaturedItems < ActiveRecord::Migration
  def self.up
    add_column :featured_items , :visible_on_right, :boolean,:default => false
  end

  def self.down
    remove_column :featured_items , :visible_on_right
  end
end
