class CitiesController < ApplicationController

  layout :layout_type

  before_filter :logged_in_admin 

  def index
    @cities = City.find(:all,:conditions =>["active is true"])
  end

  def new
    if params[:state_id]
      @city = City.new(:state => State.find(params[:state_id]))
    else
      @city = City.new
    end
  end

  def edit
    @city = City.find(params[:id])
  end

  def create
    @city = City.new(params[:city])

      if @city.save
         if params[:neighborhood]
            params[:neighborhood].split(',').each do |n|
              @city.neighborhoods.build(:name => n)
            end
          end
          @city.save

        redirect_to(@city, :notice => 'City was successfully created.')
      else
        render :action => "new"
    end
  end

    def update
    @city = City.find(params[:id])

      if @city.update_attributes(params[:city])
        if params[:neighborhood]
          @city.neighborhoods.destroy_all
          params[:neighborhood].split(',').each do |n|
            @city.neighborhoods.build(:name => n)
          end

        end
        @city.save
        redirect_to(@city, :notice => 'City was successfully updated.')
      else
        render :action => "edit"
    end
  end

  def show
    @city = City.find(params[:id])
  end

  def deactivate
    @city = City.find(params[:id])
    @city.update_attribute('active',false)
    flash[:notice] = "City has been deleted"
    redirect_to(states_path)
  end
end

