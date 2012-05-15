class CreateShippingTerms < ActiveRecord::Migration
  def self.up
    create_table :shipping_terms do |t|
      t.decimal :featured_item_cost ,:precision=>8 ,:scale => 2, :default => 0
      t.decimal :featured_item_bidding_cost ,:precision=>8 ,:scale => 2, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_terms
  end
end
