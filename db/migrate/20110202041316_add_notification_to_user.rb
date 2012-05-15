class AddNotificationToUser < ActiveRecord::Migration
  def self.up
    add_column :users ,:notification,:boolean ,:default => false
  end

  def self.down
    remove_column :users,:notification
  end
end
