class UsersController < ApplicationController
  
  layout :layout_type

  before_filter :login_user_check ,:except => [:new,:create,:account_activate,:home]
  before_filter :admin_user_check , :only => [:edit,:update,:destroy,:new,:create]
  

  def index
    @users = User.all
  end

  def show
    @title = "My Account"
    @user = User.find(params[:id])
  end

  def new
    @title = "Sign Up"
    @user = User.new
    render :layout => "application"
  end

  def edit
    @title = "Edit Your Account Details"
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "Thanks for signing up! Please check your email to activate your account. No email? Check Spam or Junk folder also."
        redirect_to login_path
      else
        render :action => "new" 
    end
  end

  def update
    @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        redirect_to(@user, :notice => 'User was successfully updated.') 
      else
        render :action => "edit" 
    end
  end

  def account_activate
      user=User.where(["activation_code = ? ", params[:act] ]).first
        unless user.nil?
         user.activation_code=nil
        user.active=1
    user.save(false)
    @activated=1  
    Notifier.welcome_mail(user).deliver   
    flash[:notice] ="Your account has been activated please login"  
    else        
    flash[:error] ="  Sorry the link has been expired or invalid"  
    end 
    return redirect_to login_path 
    
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
      redirect_to(users_url)
  end
  
  def home
    @title = "Home"
    if session[:account_type] == "admin"
      flash[:error] = "You are not allowed this action"
      redirect_to categories_path
    end  
  end
  
  def change_user_password
     unless User.authenticate(@user.email, params[:old_password])
       flash[:error]= "Please enter correct current password"
       return redirect_to  user_path(@user)
     end
     if params[:user][:password].blank?
        flash[:error]= "Password can't be blank"
        return redirect_to  user_path(@user)
     else 
       if @user.update_attributes(params[:user])
         flash[:notice]= "Your password has been updated."
         return redirect_to  user_path(@user)
       else
         render :action => "show"
       end
     end 
   end
  
  def login_user_check
    if session[:user_id]
      if session[:user_id] == params[:id].to_i || session[:account_type] == "admin"
        return true
      else
        flash[:error] = "You are not authorize to perform this action."
        redirect_to root_path
      end    
    else
      redirect_to login_path
    end    
  end
  
  def admin_user_check
    if session[:account_type] == "admin"
      flash[:error] = "You are not authorize to perform this action."
      redirect_to users_path
    end  
  end
  
end
