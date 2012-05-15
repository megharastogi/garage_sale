class CreateBiddings < ActiveRecord::Migration
  def self.up
    create_table :biddings do |t|
      t.integer :user_id
      t.decimal :bid ,:precision=>8 ,:scale => 2, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :biddings
  end
end
