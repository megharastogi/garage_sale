class ForgotPasswordController < ApplicationController

  skip_before_filter :login_check
  before_filter :not_login


  def new
     @title = "Forgot password"
    @user = User.new
  end

  def create
    @title = "Reset password"
    @user = User.where(["email = ?", params[:user][:email]]).first
    unless @user.nil?
      random_string=Digest::MD5.hexdigest(Time.now.to_i.to_s)
      #@user.update_attribute(:forgot_password_code, random_string)
      @user.forgot_password_code= random_string
      #User.after_save.clear
      @user.save(:validate => false)
      @user.send_password_recovery_mail
      flash[:notice] =  "To reset your password, follow the instructions sent to your email address. Didn't receive the email?Try again."
      return redirect_to login_path
    else
       @user = User.new
      flash.now[:error] = "Invalid email"
      render :action=> 'new'
    end
  end

  def change_password
    @title = "Reset password"
    @user=User.where(['forgot_password_code = ?', params[:forgot_password_code]]).first
    if @user.blank?
      flash[:error] = "The URL you tried to use is either incorrect or no longer valid. Please try again."
      redirect_to :action => :new
    end
  end

  def update_password
    @title = "Password updated"
    @user = User.where(['forgot_password_code = ?', params[:user][:forgot_password_code]]).first
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.forgot_password_code = params[:user][:forgot_password_code]
    if params[:user][:password].blank?
      flash.now[:error] = "Password cann't be blank."
      render :action => 'change_password'
    else
      if @user.save
       flash[:notice] = "Your password has been successfully changed."
       return redirect_to login_path
      else
        @user.forgot_password_code = params[:user][:forgot_password_code]
        render :action => 'change_password'
      end
    end
  end

  private

  def not_login
    unless session[:user_id].nil?
      redirect_to root_path
    end
  end

end

