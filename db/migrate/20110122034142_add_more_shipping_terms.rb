class AddMoreShippingTerms < ActiveRecord::Migration
  def self.up
    add_column :shipping_terms , :featured_item_on_right_cost, :decimal,:precision=>8 ,:scale => 2, :default => 0
    add_column :shipping_terms, :post_sale_cost ,:decimal,:precision=>8 ,:scale => 2, :default => 0
    add_column :shipping_terms, :sale_stats_cost,:decimal ,:precision=>8 ,:scale => 2, :default => 0
    add_column :shipping_terms,:payment_enabled ,:boolean ,:default => false
  end

  def self.down
    remove_column :shipping_terms , :featured_item_on_right_cost
    remove_column :shipping_terms , :sale_stats_cost
    remove_column :shipping_terms , :post_sale_cost
    remove_column :shipping_terms,:payment_enabled
  end
end
