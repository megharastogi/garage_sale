class Neighborhood < ActiveRecord::Base

  has_many :sales

  belongs_to :city

  after_save :fetch_geo_locations, :unless => lambda{ |a| a.skip_callback==1 }
  attr_accessor :skip_callback
 
  def fetch_geo_locations
    a= Geocoder.coordinates(self.name + " , " + self.city.name.to_s +  " , " + self.city.state.name.to_s)
    unless a.nil?
      self.latitude=a[0]
      self.longitude=a[1]
      self.skip_callback=1
      self.save(:validate => false)
    else
      self.latitude=nil
      self.longitude=nil
      self.skip_callback=1
      self.save(:validate => false)
    end
  end

end

