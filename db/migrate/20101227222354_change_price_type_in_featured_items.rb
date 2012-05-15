class ChangePriceTypeInFeaturedItems < ActiveRecord::Migration
  def self.up
      change_column :featured_items, :price, :float
  end

  def self.down
      change_column :featured_items, :price, :integer
  end
end

