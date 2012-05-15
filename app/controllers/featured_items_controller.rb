class FeaturedItemsController < ApplicationController

  before_filter :login_check
  before_filter :find_sale ,:except => [:bidding_items,:my_purchase_list]
  before_filter :login_user_check , :only => [:edit,:update,:create,:new,:destroy,:sell]
  before_filter :mailer_set_url_options ,:only =>[:sell]
  before_filter :admin_restriction 

  def index
    redirect_to sale_path(@sale)
  end

  def show
    @featured_item = FeaturedItem.find_by_id(params[:id])
    @title = "#{@featured_item.name}"
    if @sale.end_date
      @end_date = "#{@sale.end_date.year}-#{@sale.end_date.month}-#{@sale.end_date.day} #{@sale.time_to.hour}:#{@sale.time_to.min}".to_datetime
    end
    @biddings = @featured_item.user_biddings
  end

  def new
    @title = "Create Featured Item"
    if @sale.end_date && @sale.end_date <= Time.now.utc.to_date
      flash[:error] = "Your sale has expired.Please update you sale date's before creating a featured item."
      return redirect_to sale_path(@sale)
    end
    @featured_item = FeaturedItem.new
  end

  def edit
    @featured_item = FeaturedItem.find_by_id(params[:id])
    @title = "Edit #{@featured_item.name}"
    if @featured_item.sold
      flash[:error] = "You can not edit your featured item if its already sold."
      return redirect_to sale_path(@sale)
    end
  end

  def create
    @featured_item = FeaturedItem.new(params[:featured_item])
    @featured_item.sale_id = @sale.id
      if @featured_item.save
        redirect_to(sale_path(@sale), :notice => 'Featured item was successfully posted.')
      else
        render :action => "new"
    end
  end

  def update
    @featured_item = FeaturedItem.find_by_id(params[:id])
    old_bidding = @featured_item.bidding
      if @featured_item.update_attributes(params[:featured_item])
        @featured_item.update_attribute('bidding',old_bidding)
        redirect_to(sale_path(@sale), :notice => 'Featured item was successfully updated.')
      else
        render :action => "edit"
    end
  end

  def destroy
    @featured_item = FeaturedItem.find_by_id(params[:id])
    if @featured_item.sold
      flash[:error] = "You can not delete your featured item if its already sold."
    else
      @featured_item.destroy
      flash[:notice] = "Featured Item is deleted."
    end
    redirect_to(sale_path(@sale))
  end
  
  def bid
    @featured_item =  FeaturedItem.find_by_id(params[:id])
    if @sale.end_date
      @end_date = "#{@sale.end_date.year}-#{@sale.end_date.month}-#{@sale.end_date.day} #{@sale.time_to.hour}:#{@sale.time_to.min}".to_datetime

       if @end_date < Time.now
           flash[:error] = "This sale is over you can not bid on items now."
            return redirect_to sale_path(@sale)
        end
    end

    if  @featured_item.sold
      flash[:error] = "This item is already sold."
      return redirect_to sale_path(@sale)
    else
     @bidding = UserBidding.new(:featured_item_id =>@featured_item.id,:user_id => @user.id ,:bid => params[:bidding])
      if params[:bidding].to_i >= @featured_item.price
        if @bidding.save
            Notifier.bid_notification(@featured_item.sale.user,@featured_item).deliver if @featured_item.sale.user.notification
          flash[:notice] = "Your bid has been posted."
          redirect_to sale_path(@sale)
        else
          flash[:error] = "Bid has to be a number"
          redirect_to sale_path(@sale)
        end
      else
        flash[:error] = "Bid has to be a greater than set price."
        redirect_to sale_path(@sale)
      end
    end
  end

  def sell
    @featured_item = FeaturedItem.find_by_id(params[:id])
    if @featured_item.sold
      flash[:error] = "This item is already sold."
      redirect_to sale_path(@sale)
    else
      @bid = UserBidding.find_by_id(params[:bid])
      Notifier.featured_item_sale(@bid.user,@featured_item,@featured_item.sale.user,@bid.bid).deliver
      Notifier.featured_item_seller(@featured_item.sale.user,@featured_item,@bid.user,@bid.bid).deliver
      @featured_item.update_attribute("sold",true)
      @featured_item.update_attribute("user_bidding_id",@bid.id)
      @featured_item.update_attribute("user_id",@bid.user_id)
      flash[:notice] = "Featured Item has been sold."
      return redirect_to sale_path(@sale.id)
    end
  end

  def bidding_items
    @title = "My Biddings"
    @featured_items = []
    @biddings =  @user.user_biddings
    ids=[]
    @biddings.each do |b|
      unless ids.include?(b.featured_item_id)
        @featured_items << b.featured_item
      end
      ids << b.featured_item_id
    end
  end

  def my_purchase_list
    @title = "My Purchase List"
    @featured_items = FeaturedItem.find(:all,:conditions => ['sold is true AND user_id=?' , @user.id])
    render :action => "bidding_items"
  end

  protected

  def mailer_set_url_options
     ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def find_sale
    @sale = Sale.find_by_id(params[:sale_id])
    unless @sale && @sale.visible
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
  
  def admin_restriction
    if session[:account_type] == "admin"
      flash[:error] = "You are not allowed to perform this action."
      return redirect_to categories_path
    end  
   end

end

