class MessagesController < ApplicationController
  
  layout :layout_type
  
 
  skip_before_filter :login_check, :only=>[:new,:create]
  before_filter :only_admin, :only=>[:index]
  before_filter :set_user_variable_if_logged_in, :only=>[:new,:create]

  def index
    @messages = Message.order("created_at DESC").paginate(:page =>params[:page],:per_page=>10)
  end

  def new
    @title = "Contact Us"
    @message = Message.new
    unless session[:account_type].nil?
      @message.first_name =@user.first_name
      @message.last_name =@user.last_name
      @message.email =@user.email
    end
  end

  def create
    @message = Message.new(params[:message])
    if @message.save
      flash[:notice] = "We have recieved your message. We will get back to you shortly."
      redirect_to(new_message_path)
    else
      render :action => "new"
    end
  end

  private

  def set_user_variable_if_logged_in
    unless session[:account_type].nil?
      @user=User.find(:first, :conditions =>["id = ?", session[:user_id]])
    end
  end


end

