class StatesController < ApplicationController

  layout :layout_type

  before_filter :logged_in_admin 


  def index
    @states = State.find(:all,:conditions =>["active is true"])
  end

  def show
    @state = State.find(params[:id])

  end

  def new
    @state = State.new
  end

  def edit
    @state = State.find(params[:id])
  end

  def create
    @state = State.new(params[:state])
      if @state.save
        redirect_to(states_path, :notice => 'State was successfully created.')
      else
        render :action => "new"
    end
  end

  def update
    @state = State.find(params[:id])
      if @state.update_attributes(params[:state])
        redirect_to(@state, :notice => 'State was successfully updated.')

      else
        render :action => "edit"
    end
  end

  def deactivate
    @state = State.find(params[:id])
    @state.update_attribute('active',false)
      redirect_to(states_url)
  end

end

