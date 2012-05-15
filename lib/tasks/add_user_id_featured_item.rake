task :add_user_id_featured_item => :environment do
  
  @featured_items = FeaturedItem.find(:all,:conditions =>['sold is true AND user_id is null'])
  @featured_items.each do |f|
    @user_bidding = UserBidding.find_by_id(f.user_bidding_id)
    f.update_attribute('user_id',@user_bidding.user_id)
    puts "Featured Item updated"
  end 
  
  
  
  @sales = Sale.all 
  @sales.each do |s|
    s.update_attribute('active',true)
    puts 'sale updated'
  end  
    
end