class Message < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :category, :message
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
  :unless => lambda{ |a| a.email.blank? }
  validate :specify_at_least_email_or_phone



  def specify_at_least_email_or_phone
    if email=="" and phone==""
      errors.add(:base,"Please specify email or phone number")
    end
  end

  def self.categories
    ["Comments","Suggestions","Issue with account", "Site bug","Others"]
  end

end

