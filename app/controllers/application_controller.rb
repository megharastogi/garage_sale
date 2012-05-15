class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :login_check
  before_filter :mailer_set_url_options
  before_filter :find_user
  helper :all
  
  
  def payment_enabled?
    @shipping_terms = ShippingTerm.first
    @shipping_terms.payment_enabled
  end  
  

private

  def find_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end

  def logged_in_admin
    if session[:account_type] == "admin"
      return true
    else
      flash[:error] = "Please log in as admin."
      return redirect_to login_path
    end
  end

  def login_check
    # logger.debug("==============inside login check==============")
    if session[:user_id]   # incase of site navigation
      @user=User.find(:first, :conditions =>["id = ?", session[:user_id]])
      set_user_login_attributes
    elsif  cookies[:key] and @user=User.find(:first, :conditions =>["remember_me = ?", cookies[:key]]) #case for remember me
      set_user_login_attributes
      redirect_to root_path
    else   # case when user is not logged in
      redirect_to login_path
    end
  end

 def mailer_set_url_options
    # logger.debug("==============inside mailer set url options==============")
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

 def set_user_login_attributes
    session[:user_id] = @user.id
    session[:account_type] = @user.account_type 
  end

  def layout_type
    session[:account_type] == "admin" ? "admin" : "application"
  end

  def only_admin
    unless session[:account_type]=="admin"
        flash[:error]="You are not authorized for this action."
        redirect_to root_path
    end

  end

end

