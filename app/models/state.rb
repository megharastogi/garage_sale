class State < ActiveRecord::Base

  has_many :cities
  has_many :sales
  
  validates_presence_of :name 
  
  def active_cities
    self.cities.find(:all,:conditions =>["active is true"])
  end  
  
end
