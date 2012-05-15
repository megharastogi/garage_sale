class ShippingTerm < ActiveRecord::Base
  
  validates_numericality_of :featured_item_cost ,:featured_item_bidding_cost,:post_sale_cost,:sale_stats_cost,:featured_item_on_right_cost 
  
end
