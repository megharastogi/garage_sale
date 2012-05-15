class AddUserIdToFeaturedItems < ActiveRecord::Migration
  def self.up
    add_column :featured_items , :user_id,:integer
  end

  def self.down
    remove_column :featured_items , :user_id
  end
end
