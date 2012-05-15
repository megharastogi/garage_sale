class CategoriesController < ApplicationController

  layout :layout_type

  before_filter :logged_in_admin
  before_filter :load_category , :only => [:edit,:update,:deactivate]
  
  
  def index
    @categories = Category.find(:all,:conditions =>["active is true"])
  end

  def new
    @category = Category.new
  end

  def edit

  end


  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to(categories_path, :notice => 'Category was successfully created.')
    else
      render :action => "new"
    end  
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to(categories_path, :notice => 'Category was successfully updated.')
    else
      render :action => "edit" 
    end  
  end

  def deactivate
    @category.update_attribute('active',false)
    flash[:notice] = "Category has been deleted"
    redirect_to(categories_url)
  end

  private
  
  def load_category
    @category = Category.find_by_id(params[:id])
    if @category.nil?
      flash[:error] = 'No such category exists.'
      redirect_to(categories_path)
    end
  end
    
end


