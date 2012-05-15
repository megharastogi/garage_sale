class SessionsController < ApplicationController
   skip_before_filter :login_check, :only=>[:new,:create]
   before_filter :logged_in, :except=>[:destroy]
   #ssl_required :new, :create
   
  def new
    # render login page. ie new session
    @title = "Login"
    @user = User.new
  end

  def destroy
    if cookies[:key]
      User.update(session[:user_id],:remember_me=>'')
    end
    reset_session
    redirect_to login_path
  end

  def create
    # validating login credentials and after that creating new session    
    if @user = User.authenticate(params[:user][:email], params[:user][:password])
       if params[:remember]=='1'
          random_value=User.random_string
          cookies[:key] = { :value => random_value, :expires => 1.year.from_now }
          @user.remember_me=random_value
          @user.save
        end
      if @user.active == 0
        flash[:error] = "Please Activate your account by clicking on the link sent in your mail."
        return redirect_to login_path
      else    
        set_user_login_attributes
        if session[:account_type] == "admin"
          return redirect_to categories_path
        else
          if session[:sale]
            return redirect_to new_sale_path
          else
            return redirect_to sales_path
          end  
        end
      end  
    else
      invalid_login
    end
  end  

  private
  
  def invalid_login
    flash[:error] = "The username or password you entered is incorrect."
    @user= User.new
    redirect_to login_path
  end
  
  def logged_in
    if session[:user_id]
      redirect_to root_path
    end  
  end  
 

end
