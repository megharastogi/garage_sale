class SaleView < ActiveRecord::Base
     belongs_to :sale, :counter_cache => true
end

