class UserBidding < ActiveRecord::Base
    belongs_to :featured_item  
    belongs_to :user  
    
    validates_presence_of :user_id,:featured_item_id,:bid
    validates_numericality_of :bid
end
