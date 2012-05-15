class FeaturedItem < ActiveRecord::Base
 
 has_attached_file :sample,   :styles => {:thumb=> "150x100>",:medium => "176x117>",:large=>"250x180>" }
 belongs_to :sale, :counter_cache => true
 validates_presence_of :name ,:description,:bidding
 validates_presence_of :price, :if => lambda{ |a| a.bidding  == 1 }
 validates_numericality_of :price ,:greater_than => 0, :unless => lambda{ |a| a.price.blank? or a.bidding  != 1 }
 before_save :minimum_price_save
 has_many :user_biddings
 has_many :users , :through => :user_biddings

 def minimum_price_save
   unless bidding == 1
     price = nil
   end
 end
 
 def max_bid
  biddings = self.user_biddings.all.collect{|c| c.bid}
  if biddings.blank?
    return "---"
  else
    return "$" + biddings.max.to_s
  end    
 end 

end

