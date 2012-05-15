class Notifier < ActionMailer::Base
  default :from => "TheGarageSaler,notifications@thegaragesaler.com"

  def account_activation_mail(recipient)
    @recipient = recipient
    mail(:to => @recipient.email, :subject => "Just one more step to get started on Garage Sale")  
  end

  def welcome_mail(recipient)
    @recipient = recipient
    mail(:to => @recipient.email, :subject => "Welcome to Garage Sale")  
  end

  def password_recovery(recipient)
    @recipient = recipient
    mail(:to => recipient.email, :subject => "Garage Sale Password Assistance")
  end 

  def featured_item_sale(recipient,featured_item,seller,bid)
    @recipient = recipient
    @featured_item = featured_item
    @seller = seller
    @bid = bid
    mail(:to => recipient.email, :subject => "Garage Sale Featured Item")
  end 

  def featured_item_seller(recipient,featured_item,buyer,bid)
    @recipient = recipient
    @featured_item = featured_item
    @buyer = buyer
    @bid = bid
    mail(:to => recipient.email, :subject => "Garage Sale Featured Item")
  end

  def email_sales_list(recipient,sales)
    @recipient = recipient
    @sales = sales
    mail(:to => recipient.email, :subject => "Garage Sale Sales List")
  end   

  def bid_notification(recipient,featured_item)
    @recipient = recipient
    @featured_item = featured_item
    mail(:to => recipient.email, :subject => "Garage Sale Featured Item Bid")
  end

end
