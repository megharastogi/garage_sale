class PagesController < ApplicationController
  def about_us
    @title = "About Us"
  end

  def terms_of_use
    @title = "Terms Of Use"
    
  end

  def privacy_policy
    @title = "Privacy Policy"
    
  end
  
  def analytics_report
    @title = "Analytics Report"
  end  

end
