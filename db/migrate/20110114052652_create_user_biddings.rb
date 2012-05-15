class CreateUserBiddings < ActiveRecord::Migration
  def self.up
    create_table :user_biddings do |t|
      t.integer :user_id
      t.integer :featured_item_id
      t.decimal :bid ,:precision=>8 ,:scale => 2, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :user_biddings
  end
end
