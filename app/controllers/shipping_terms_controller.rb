class ShippingTermsController < ApplicationController
  
  layout :layout_type

  before_filter :logged_in_admin 
  
  
  def show
    @shipping_term = ShippingTerm.find(:first)
  end
  
  def edit
    @shipping_term = ShippingTerm.find(:first)
  end  

  def update
    @shipping_term = ShippingTerm.find(:first)
    if @shipping_term.update_attributes(params[:shipping_term])
      flash[:notice] ="Shipping Terms updated"
      redirect_to shipping_term_path(@shipping_term)
    else
      render :action => "edit"
    end    
  end  
end

