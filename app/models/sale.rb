class Sale < ActiveRecord::Base


  belongs_to :user
  belongs_to :state
  belongs_to :city
  has_many :sale_views
  has_many :featured_items
  has_many :comments
  has_many :favorite_sales
  has_many :users , :through => :favorite_sales
  has_and_belongs_to_many :categories
  belongs_to :neighborhood
  validates_presence_of :name ,:state_id,:city_id,:description,:start_date,:end_date,:street,:zipcode

  validate :validate_category
  after_save :fetch_geo_locations, :unless => lambda{ |a| a.skip_callback==1 }
  attr_accessor :skip_callback
 
  def fetch_geo_locations
    a= Geocoder.coordinates(self.street.to_s + " , " + self.city.name.to_s +  " , " + self.city.state.name.to_s + ", " + self.zipcode.to_s)
    unless a.nil?
      self.latitude=a[0]
      self.longitude=a[1]
      self.skip_callback=1
      self.save(:validate => false)
    else
      self.latitude=nil
      self.longitude=nil
      self.skip_callback=1
      self.save(:validate => false)
    end
  end
  
  
  def self.sort_sale(sort_way,page_number)
    if sort_way == "end_date"
      find(:all,:conditions => ["visible is true and active is true and (end_date > NOW() or end_date is null) "],:order => "end_date DESC").paginate(:page =>page_number, :per_page => 5)
    else  
      find(:all,:conditions => ["visible is true and active is true and (end_date > NOW() or end_date is null) "],:order => "start_date DESC").paginate(:page => page_number, :per_page => 5)
    end
  end  
  
  def self.my_sale(sort_way,page_number,user_id)
    if sort_way == "end_date"
      find(:all,:conditions => ["user_id=? and active is true",user_id] ,:order => "end_date DESC").paginate(:page =>page_number, :per_page => 5)
    else
      find(:all,:conditions => ["user_id=? and active is true",user_id] ,:order => "start_date DESC").paginate(:page => page_number, :per_page => 5)
    end
  end  

  def validate_category
    if self.categories.blank?
      self.errors.add(:category, 'can not be blank')
    else
      self.categories.each do |c|
        Category.all.include?(c) ? true : self.errors.add(:category, 'doesnt exisits.')
      end
    end
  end


  def all_featured_id_paid?
    @featured_item = FeaturedItem.find(:all ,:conditions => ["sale_id = ? and transaction_id is null",self.id])
    if @featured_item.blank?
      return true
    else
      return false
    end
  end

  def paid_featured_items
    @featured_item = FeaturedItem.find(:all ,:conditions => ["sale_id = ? and transaction_id is not null",self.id])
  end

  def unpaid_featured_items
    @featured_item = FeaturedItem.find(:all ,:conditions => ["sale_id = ? and transaction_id is null",self.id])
  end
  
  def unpaid_item_price_calculation
    @total = 0
    @shipping_terms = ShippingTerm.first
    self.unpaid_featured_items.each do |f|
      price = 0
      f.bidding == 1 ? price = (@shipping_terms.featured_item_bidding_cost + @shipping_terms.featured_item_cost) : price = @shipping_terms.featured_item_cost
      f.visible_on_right ? price + @shipping_terms.featured_item_on_right_cost : ''
      @total = @total + price  
    end  
    return @total
  end  

  def feature_item_paid(transaction_id)
    self.featured_items.each do |f|
      if f.transaction_id.blank?
        f.update_attribute('transaction_id',transaction_id)
      end
    end
  end
  
  def self.active_sales
    @sales = Sale.find(:all,:conditions => ["visible is true and active is true and (end_date > NOW() or end_date is null) "], :order => "RAND()")
  end  
  
  def self.active_featured_items
    @featured_items = []
    Sale.active_sales.each do |sale|
      @featured_items << sale.featured_items.find(:all,:conditions =>["active is true AND transaction_id is not NULL AND sold is false"])
      @featured_items = @featured_items.flatten
    end 
    return @featured_items[0..2]
  end  

  def self.paypal_payment_transaction(credit_card,request_ip,amount)
    @response = gateway.purchase(amount*100,credit_card,:ip => request_ip)
  end

  def self.gateway
    paypal
  end

  def self.paypal
    @paypal ||=  ActiveMerchant::Billing::Base.gateway(:paypal).new(config_from_file('paypal.yml'))
  end

  def self.config_from_file(file)
    YAML.load_file(File.join(RAILS_ROOT, 'config', file))[RAILS_ENV].symbolize_keys
  end

  def check_for_counter_increment(user_ip, viewer_id)
    unless self.user_id == viewer_id
        if SaleView.where("created_at > ? and ip = ? and sale_id = ?",2.minutes.ago,user_ip,self.id).count == 0
                sale_view = SaleView.new
                sale_view.sale_id = self.id
                sale_view.ip = user_ip
                sale_view.save
        end
    end
  end

  def self.plan_route_search(categories=nil,state_id=nil,city_id=nil,neighborhoods=nil,start_date =nil,end_date=nil,time_from=nil,time_to=nil,sale_order=nil)
    unless categories.blank?
     @sql = "SELECT DISTINCT * FROM sales where id in (SELECT DISTINCT sale_id FROM categories_sales where category_id in (#{categories.join(',')})) AND visible is true AND active is true and (end_date > NOW() or end_date is null) "
     sales = @sales = Sale.find_by_sql(@sql) 
    else
     if sale_order == "end_date"
       sales  = Sale.find(:all,:conditions => ["visible is true AND active is true and (end_date > NOW() or end_date is null) "],:order => :end_date)
     else
       sales  = Sale.find(:all,:conditions => ["visible is true AND active is true and (end_date > NOW() or end_date is null)"],:order => :start_date)
     end    
    end      
    @sales = []
    unless state_id.blank?
      sales.each do |sale|
        if !city_id.blank?        
          if sale.state_id == state_id.to_i && sale.city_id == city_id.to_i 
            if neighborhoods.blank?
              @sales << sale
            else  
              i = 0
              neighborhoods.each do |n| 
                if sale.neighborhood_id == (n.to_i) && i == 0
                  @sales << sale
                  i = 1
                end
              end    
            end
          end  
        else
          sale.state_id == state_id.to_i ? @sales << sale : ''
        end    
      end    
    else
      @sales = sales
    end   
    
    @date_sales =[]
    if !start_date.blank? 
      @sales.each do |sale|           
        if sale.start_date >= start_date.to_date && end_date.to_date >= sale.start_date 
            @date_sales << sale
        end  
      end        
      @sales = @date_sales
    end    
    @time_sale = []
    if time_to != "" && time_from != "" 
      @time_to = "2000-01-01 #{time_to}:00"
      @time_from = "2000-01-01 #{time_from}:00"
      @sales.each do |sale|
        if @time_from.to_time >= sale.time_from && sale.time_to >= @time_to.to_time
          @time_sale << sale
        end  
        
      end  
      @sales = @time_sale
    end  
    @sales
  end  

end

