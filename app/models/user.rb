class User < ActiveRecord::Base

  include ActiveMerchant::Billing::CreditCardMethods

  has_many :sales
  has_many :messages
  has_many :comments
  has_many :favorite_sales
  has_many :sales , :through => :favorite_sales
  has_many :user_biddings
  has_many :featured_items , :through => :user_biddings
  attr_accessor :password, :terms,:remember_me
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validates_length_of :password, :within => 6..20, :unless => lambda{ |a| a.password.blank? }
  validates_presence_of :email, :first_name, :last_name, :sex, :street, :city, :state, :zipcode
  validates_presence_of :password , :if => lambda{|a| a.new_record?}
  validates_uniqueness_of :email , :unless => lambda{|a| a.email.blank?}
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
  :unless => lambda{ |a| a.email.blank? }

  validates_acceptance_of :terms, :message => "must be accepted"
  after_create :send_activation_mail
  before_create :generate_activation_code

  def full_name
    [first_name,last_name].join(' ')
  end

  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def generate_activation_code
    self.notification = true
    self.activation_code = Digest::MD5.hexdigest(rand.to_s +  rand.to_s) unless self.account_type == "admin"
  end
  
  def fav_sales(sale) 
    @fav = FavoriteSale.find(:first,:conditions =>["user_id = ? and sale_id = ?", self.id,sale.id])
    if @fav
      return true
    else
      return false
    end    
  end  

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def send_activation_mail
    Notifier.account_activation_mail(self).deliver unless self.account_type == "admin"
  end

  def send_password_recovery_mail
    Notifier.password_recovery(self).deliver
  end

  def self.random_string
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(10) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def send_password_recovery_mail
    Notifier.password_recovery(self).deliver
  end

  def password
    @password
  end

  def create_new_salt
    self.salt = Digest::MD5.hexdigest(rand.to_s)
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end



end

