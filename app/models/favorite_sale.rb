class FavoriteSale < ActiveRecord::Base
  belongs_to :sale, :counter_cache => true
  belongs_to :user  
end
