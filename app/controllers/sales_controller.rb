class SalesController < ApplicationController

  before_filter :store_location , :except => :email_list
  before_filter :login_check , :except => [:index,:show,:load_city,:load_neighborhoods,:post_sale,:plan_sale,:plan_route,:search]
  before_filter :find_sale_and_visible ,:except =>[:new,:post_sale,:create,:index,:plan_route,:search,:load_city,:load_neighborhoods,:post_sale,:sale_payment_details,:sale_money_transaction,:plan_sale,:my_fav_sales,:my_sales,:email_list,:search]
  before_filter :find_sale , :only =>[:sale_payment_details,:sale_money_transaction]
  before_filter :login_user_check , :only => [:edit,:update,:deactivate,:payment_details,:money_transaction,:sale_stats,:sale_payment_details,:sale_money_transaction]
  before_filter :admin_restriction 

  def index
    @title = "All Sales"
    @sales = Sale.sort_sale(params[:sale_order],params[:page])
    @featured_items = Sale.active_featured_items
  end

  def show
    @title = "#{@sale.name}"
    @sale.check_for_counter_increment(request.remote_ip, session[:user_id] )
    if @sale.end_date
      @end_date = "#{@sale.end_date.year}-#{@sale.end_date.month}-#{@sale.end_date.day} #{@sale.time_to.hour}:#{@sale.time_to.min}".to_datetime
    end
    if session[:user_id] == @sale.user_id
      @featured_items = @sale.featured_items
    else
      @featured_items = @sale.paid_featured_items
    end
  end

  def new
    @title = "Post Garage Sale"
    if session[:sale]
      @sale = session[:sale]
      @cities = @sale.state.cities
      if @sale.city_id
        @neighborhoods = @sale.city.neighborhoods
        @selected_neighborhood = @sale.neighborhood
      else
        @neighborhoods =[]
        @selected_neighborhoods = []
      end
      session[:sale]=nil
      @selected_categories = []
    else
      @sale = Sale.new
      @cities = []
      @neighborhoods = []
      @selected_neighborhoods = []
      @selected_categories = []
    end
    
    @sale.street = @user.street
    @sale.zipcode = @user.zipcode
  end

  def my_fav_sales
    @title = "My Favorite Sales"
    @sales = []
    @user.favorite_sales.each do |f|
      if f.sale.active
        @sales << f.sale
      end
    end
    if params[:sale_order] == "end_date"
      @sales = @sales.sort_by{|sale| sale.end_date}
    else
      @sales = @sales.sort_by{|sale| sale.start_date}
    end
    @sales = @sales.reverse.paginate(:page => params[:page], :per_page => 5)
    @featured_items = Sale.active_featured_items
    render :action => "index"
  end

  def my_sales
    @title = "My Sales"
    @sales = Sale.my_sale(params[:sale_order],params[:page],@user.id)
    @featured_items = Sale.active_featured_items
    render :action => "index"
  end

  def post_sale    
    unless params[:sale][:state_id].blank?
      session[:sale] = Sale.new(params[:sale])
      if session[:user_id]
        @sale = session[:sale]
        redirect_to new_sale_path
      else
        flash[:notice] = "You must login before you post your sale"
        redirect_to login_path
      end
    else
      flash[:error] = "You must select a state before posting a sale."
      redirect_to root_path
    end
  end

  def plan_sale
    unless params[:sale][:state_id].blank?
      session[:sale] = Sale.new(params[:sale])
      @sale = session[:sale]
      redirect_to plan_route_sales_path
    else
      flash[:error] = "You must select a state before posting a sale."
      redirect_to root_path
    end
  end

  def edit
    @cities = @sale.state.cities
    @neighborhoods = @sale.city.neighborhoods
    @selected_neighborhood = @sale.neighborhood
    @selected_categories = @sale.categories.collect {|n| n.id.to_s}
  end

  def create
    @sale = Sale.new(params[:sale])
    @sale.user_id = session[:user_id]
    if @sale.valid?
      @shipping_terms = ShippingTerm.first
      if payment_enabled? && (@shipping_terms.post_sale_cost != 0.0 || @shipping_terms.sale_stats_cost != 0.0 )
        @sale.save
        return redirect_to sale_payment_details_sale_path(@sale)
      else
        @sale.visible = true
        @sale.save
        redirect_to(@sale, :notice => 'Sale was successfully created.')
      end
    else
      populate_checkbox_drop_downs
      render :action => "new"
    end
  end

  def update
    if @sale.update_attributes(params[:sale])
      if @sale.visible
        redirect_to(@sale, :notice => 'Sale was successfully updated.')
      else
        redirect_to(sale_payment_details_sale_path(@sale), :notice => 'Sale was successfully updated.')
      end    
    else
      populate_checkbox_drop_downs
      render :action => "edit"
    end
  end


  def deactivate
    @sale.update_attribute('active',false)
    @sale.featured_items.each do |f|
      f.update_attribute('active',false)
    end
    flash[:notice]= "Your sale has been deleted."
    redirect_to(sales_url)
  end

  def plan_route
    @title = "Plan My Route"

    session[:search_params] = nil
    if session[:sale]
      @sale = session[:sale]
      @cities = @sale.state.cities
      if @sale.city_id
        @neighborhoods = @sale.city.neighborhoods
        if @sale.neighborhood
          @selected_neighborhoods = @sale.neighborhood.id
        else
          @selected_neighborhoods =[]
        end    
      else
        @neighborhoods =[]
        @selected_neighborhoods = []
      end
      session[:sale]=nil
    else
      @cities = []
      @neighborhoods = []
      @selected_neighborhoods = []
    end
    @selected_categories = []
  end

  def sale_stats
    @title = "Sale Stats"
    unless @sale.stats
      flash[:error] = "You are not authorize to perform this action."
      return redirect_to sale_path(@sale)
    end
  end

  def search    
    if session[:search_params] 
      params[:sale] = session[:search_params] 
    end
    if params[:sale]['time_from(4i)'] == ""
      @time_from = ""
    else
      @time_from = (params[:sale]['time_from(7i)'] == "-2" ? (params[:sale]['time_from(4i)']== "12" ? "12" : params[:sale]['time_from(4i)'].to_i + 12).to_s :  (params[:sale]['time_from(4i)'] == "12" ? "00" : params[:sale]['time_from(4i)'])) + ":" + (params[:sale]['time_from(5i)'] == "" ? "00" : params[:sale]['time_from(5i)'])
    end
    if params[:sale]['time_to(4i)'] == ""
      @time_to = ""
    else
      @time_to =  (params[:sale]['time_to(7i)'] == "-2" ? (params[:sale]['time_to(4i)']  == "12" ? "12" : params[:sale]['time_to(4i)'].to_i + 12).to_s : (params[:sale]['time_to(4i)'] == "12" ? "00" : params[:sale]['time_to(4i)'])) + ":" + (params[:sale]['time_to(5i)'] == "" ? "00" : params[:sale]['time_to(5i)'])
    end
    if session[:search_params] 
      unless params[:sale_order]
        session[:search_params] = nil
      end  
    else
      session[:search_params] = params[:sale]
    end        
    @sales = Sale.plan_route_search(params[:sale][:category_ids],params[:sale][:state_id],params[:sale][:city_id],params[:sale][:neighborhood_ids],params[:start_date],params[:end_date],@time_from,@time_to,params[:sale_order]).paginate(:page => params[:page], :per_page => 5)
    @featured_items = Sale.active_featured_items
    render :action => "index"
  end

  def load_city
    respond_to do |format|
      unless params[:state_id]==""
        @cities = State.find(params[:state_id]).active_cities
      else
        @cities=[]
      end
      format.js{
        render :update do |page|
          if params[:home_page] && params[:plan_sale]
            page.replace_html "state_cities_plan", ("<label>City</label>" + select("sale", "city_id", @cities.collect {|c| [ c.name.capitalize, c.id ] }.sort, {:include_blank => 'Select a city'},{:onchange => remote_function(:url => {:action => 'load_neighborhoods'},
            :with => "'city_id='+this.value+'&home_page=true&plan_sale=true'"
            )}))
          elsif params[:home_page]
            page.replace_html "state_cities_123", ("<label>City</label>" + select("sale", "city_id", @cities.collect {|c| [ c.name.capitalize, c.id ] }.sort, {:include_blank => 'Select a city'},{:onchange => remote_function(:url => {:action => 'load_neighborhoods'},
            :with => "'city_id='+this.value+'&home_page=true'"
            )}))
          elsif params[:plan_route]
            page.replace_html "state_cities_123", ("<label>City</label>" + select("sale", "city_id", @cities.collect {|c| [ c.name.capitalize, c.id ] }.sort, {:include_blank => 'Select a city'},{:onchange => remote_function(:url => {:action => 'load_neighborhoods'},
            :with => "'city_id='+this.value+'&plan_route=true'"
            )}))
          else
            page.replace_html "state_cities_123", ("<label>City</label>" + select("sale", "city_id", @cities.collect {|c| [ c.name.capitalize, c.id ] }.sort, {:include_blank => 'Select a city'},{:onchange => remote_function(:url => {:action => 'load_neighborhoods'},
            :with => "'city_id='+this.value"
            )}))
          end
        end
      }
    end
  end

  def load_neighborhoods
    respond_to do |format|
      @neighborhoods = City.find(params[:city_id]).neighborhoods
      format.js{
        render :update do |page|
          if params[:home_page] && params[:plan_sale]
            page.replace_html "city_neighborhood_plan", "<label>Neighborhoods</label>"
            @c = @neighborhoods.collect{ |u| [u.name, u.id] }
            @c = @c.insert(0,['Select a neighborhood',''])
            page.insert_html :bottom , 'city_neighborhood_plan',  (select_tag 'sale[neighborhood_id]', options_for_select(@c))
          elsif params[:home_page]
            page.replace_html "city_neighborhood", "<label>Neighborhoods</label>"
            @c = @neighborhoods.collect{ |u| [u.name, u.id] }
            @c = @c.insert(0,['Select a neighborhood',''])
            page.insert_html :bottom , 'city_neighborhood',  (select_tag 'sale[neighborhood_id]', options_for_select(@c))
          elsif params[:plan_route]
            page.replace_html "city_neighborhood", "<label>Neighborhoods</label>"

            @neighborhoods.each do |n|
              page.insert_html :bottom , 'city_neighborhood', ('<p>' + check_box_tag('sale[neighborhood_ids][]', n.id) + n.name + '</p>')
            end
          else
            page.replace_html "city_neighborhood", "<label>Neighborhoods</label>"

            @neighborhoods.each do |n|
              page.insert_html :bottom , 'city_neighborhood', ('<p> ' + radio_button_tag('sale[neighborhood_id]', n.id) + "&nbsp;" +n.name + '</p>')
            end
          end
        end
      }
    end
  end

  def add_to_favorite
    @already_fav_sale = FavoriteSale.find(:first,:conditions =>["user_id = ? AND sale_id = ?",@user.id,@sale.id])
    if @already_fav_sale
      flash[:error] = "Sale is already in your favorites."
    else
      @fav_sale = @user.favorite_sales.build(:sale_id => @sale.id)
      @fav_sale.save
      flash[:notice] = "Sale has been added to your favorites."
    end
    if params[:show_page]
      redirect_to sale_path(@sale)
    else
      redirect_to sales_path
    end
  end

  def remove_favorite
    @fav_sale = FavoriteSale.find(:first , :conditions => ["user_id = ? and sale_id = ?",@user.id,@sale.id])
    if @fav_sale
      @fav_sale.destroy
      flash[:notice] = "Sale has been removed from your favorites."
    else
      flash[:error] = "You are not authorize to perform this action."
    end
    if params[:show_page]
      redirect_to sale_path(@sale)
    else
      redirect_to sales_path
    end
  end

  def payment_details
    if @sale.end_date && @sale.end_date <= Time.now.utc.to_date
      flash[:error] = "Your sale is over.Please update you sale date's before posting any featured items."
      return redirect_to sale_path(@sale)
    end  
    @shipping_terms = ShippingTerm.first
    if payment_enabled? && (@shipping_terms.featured_item_cost != 0.0 || @shipping_terms.featured_item_bidding_cost + @shipping_terms.featured_item_on_right_cost != 0.0)
    else
      @sale.unpaid_featured_items.each do |f|
        f.update_attribute("transaction_id","payment_disabled")
      end
      flash[:notice] = "Your Featured Items has been posted."
      redirect_to sale_path(@sale)
    end
  end

  def sale_payment_details
    @sale = Sale.find_by_id(params[:id])
    if @sale.visible
      flash[:error] = 'Sale already posted.'
      return redirect_to sale_path(@sale)
    end  
    if @sale.end_date && @sale.end_date <= Time.now.utc.to_date
      flash[:error] = "Your sale is over.Please update you sale date's before posting the sale."
      return redirect_to sale_path(@sale)
    end
    @shipping_terms = ShippingTerm.first
  end

  def sale_money_transaction
    if @sale.end_date && @sale.end_date <= Time.now.utc.to_date
      flash[:error] = "Your sale has expired.Please update you sale date's before posting the sale."
      return redirect_to sale_path(@sale)
    end
    @shipping_terms = ShippingTerm.first
    @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
    if @creditcard.valid?
      @amount = @sale.stats ? @shipping_terms.post_sale_cost + @shipping_terms.sale_stats_cost : @shipping_terms.post_sale_cost
      @response = Sale.paypal_payment_transaction(@creditcard,request.remote_ip,@amount)
      if @response.success?
        @sale.update_attribute('transaction_id',@response.params["transaction_id"])
        @sale.update_attribute('visible',true)
        flash[:notice] = "Sale was successfully created."
        return redirect_to sale_path(@sale)
      else
        flash[:error] = @response.message
        render :action => :sale_payment_details
      end
    else
      render :action => :sale_payment_details
    end
  end

  def money_transaction
    if @sale.end_date && @sale.end_date <= Time.now.utc.to_date
      flash[:error] = "Your sale has expired.Please update you sale date's before posting the sale."
      return redirect_to sale_path(@sale)
    end
    @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
    if @creditcard.valid?
      @response = Sale.paypal_payment_transaction(@creditcard,request.remote_ip,@sale.unpaid_item_price_calculation)
      if @response.success?
        @sale.feature_item_paid(@response.params["transaction_id"])
        flash[:notice] = "Your transaction was successful and your featured items has been posted."
        return redirect_to sale_path(@sale)
      else
        flash[:error] = @response.message
        render :action => :payment_details
      end
    else
      render :action => :payment_details
    end
  end

  def populate_checkbox_drop_downs
    unless params[:sale][:state_id] == ""
      @cities = State.find(params[:sale][:state_id]).cities
    else
      @cities = []
    end
    unless params[:sale][:city_id] == ""
      @neighborhoods = City.find(params[:sale][:city_id]).neighborhoods
    else
      @neighborhoods = []
    end
    unless params[:sale][:neighborhood_ids] == ""
      @selected_neighborhoods=params[:sale][:neighborhood_ids]
    else
      @selected_neighborhoods = []
    end
    unless params[:sale][:category_ids] == "" or  params[:sale][:category_ids].nil?
      @selected_categories = params[:sale][:category_ids]
    else
      @selected_categories = []
    end
  end

  def email_list
    if params[:sales]
      Notifier.email_sales_list(@user,params[:sales]).deliver
      flash[:notice] = "List has been mailed to you"
    else
      flash[:error] =  "There are not sales present on the page."
    end
    if session[:return_to]
      return redirect_to session[:return_to]
    else 
      return redirect_to sales_path
    end   
  end
  
  def get_directions
    
  end  

  protected


  def find_sale_and_visible     
    @sale = Sale.find_by_id(params[:id])
    unless @sale && (@sale.visible || session[:user_id] == @sale.user_id) && @sale.active
      flash[:error] = "Sale you are trying to access doesn't exists."
      return redirect_to sales_path
    end
  end

  def find_sale
    @sale = Sale.find_by_id(params[:id])
    unless @sale
      flash[:error] = "Sale you are trying to access doesn't exists."
      return redirect_to sales_path
    end
  end

  def login_user_check
    if @sale.user_id == @user.id
      return true
    else
      flash[:error] = "You are not authorize to perform this action."
      redirect_to sale_path(@sale)
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end 

  def admin_restriction
    if session[:account_type] == "admin"
      flash[:error] = "You are not allowed to perform this action."
      return redirect_to categories_path
    end  
  end   
end

