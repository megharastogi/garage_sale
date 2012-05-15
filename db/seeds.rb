# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@state = State.find_by_name("Georgia")
unless @state
  @state = State.create(:name => "Georgia")
end   
# 
# ["Abba","Abbeville","Acworth","Adairsville","Adel","Adrian","Ailey","Alamo","Alapaha","Albany","Allenhurst","Alma","Alpharetta","Alston","Amboy","Ambrose","Americus","Appling",
# "Arlington","Ashburn","Athens","Athens-Clarke County","Atkinson","Atlanta","Attapulgus","Auburn","Augusta","Augusta-Richmond County","Austell","Avondale Estates","Axson",
# "Zebulon","Wrightsville","Walthourville","Warner Robins","Warrenton","Warwick","Washington","Waterloo","Watkinsville","Waverly","Waycross","Waynesboro","Waynesville","Weber","West Green","West Point","Westwood",
# "Whigham","White Oak","Whitmarsh Island","Willacoochee","Wilmington Island","Winder","Winokur","Withers","Woodbine","Woodstock","Worth","Wray","Valdosta","Valona","Vernonburg","Vidalia","Vienna","Villa Rica",
# "Talbotton",
# "Tallapoosa",
# "Tarboro",
# "Tarver",
# "Temple",
# "Thalman",
# "Thelma","Thomaston","Thomasville","Thomson","Thunderbolt","Tifton","Toccoa","Toomsboro","Townsend","Trenton","Trudie","Tucker","Twin City","Twin Lakes","Ty Ty","Tybee Island","Tyrone",
# "Saint George",
# "Sale City",
# "Sandersville",
# 
# "Sandy Springs",
# 
# "Sasser",
# 
# "Savannah",
# 
# "Screven",
# 
# "Senoia",
# 
# "Sessoms",
# 
# "Shawnee",
# 
# "Shellman Bluff",
# 
# "Sirmans",
# 
# "Skidaway Island",
# 
# "Smithville",
# 
# "Smyrna",
# 
# "Snellville",
# 
# "Social Circle",
# 
# "Soperton",
# 
# "South Newport",
# 
# "Sparks",
# 
# "Sparta",
# 
# "Springfield",
# 
# "St. Marys",
# 
# "St. Simons Island",
# 
# "Statenville",
# 
# "Statesboro",
# 
# "Sterling",
# 
# "Stillmore",
# 
# "Stillwell",
# 
# "Stilson",
# 
# "Stockbridge",
# 
# "Stockton",
# 
# "Stone Mountain",
# 
# "Sugar Hill",
# 
# "Sumner",
# 
# "Sunbury",
# 
# "Sunsweet",
# 
# "Surrency",
# 
# "Suwanee",
# 
# "Swainsboro",
# 
# "Sycamore",
# 
# "Sylvania",
# 
# "Sylvester",
# "Race Pond",
# "Ray City",
# "Rebecca",
# "Register","Reidsville","Remerton","Rentz","Retreat","Riceboro","Richmond Hill","Ridgeville","Rincon","Ringgold","Riverdale","Riverside","Rochelle","Rockingham","Rockmart","Rome","Roswell","Royston","Rutledge","Palmetto","Parrott","Patterson","Peachtree City Website","Pearson","Pelham","Pembroke",
# 
# "Perry",
# 
# "Phillipsburg",
# 
# "Pine Lake",
# 
# "Pineora",
# 
# "Pineview",
# 
# "Pooler",
# 
# "Port Wentworth",
# 
# "Portal",
# 
# "Potter",
# 
# "Poulan",
# 
# "Powder Springs",
# 
# "Preston",
# 
# "Pridgen",
# 
# "Pulaski",
# "Queensland",
# 
# "Quitman"
# ].each do |name|

["Atlanta (metro area)","Atlanta (inside the perimeter)"].each do |name|
  @city = City.first(:conditions => ["name = ?", name])
  if @city
    puts "----------------------City (#{name}) already exists-------------------"
  else
    @city = City.create(:name => name , :state_id => @state.id)
    puts "----------------------City (#{name}) has been created-------------------"
  end
  
end
 @city1 = City.first(:conditions => ["name = ?", "Atlanta (metro area)"])
 ["Roswell", "Sandy", "Springs", "Duluth", "Johns", "Creek", "Lawrenceville", "Norcross", "Marietta", "Alpharetta", "Canton", "Woodstock", "Peachtree", "City", "Smyrna", "Dunwoody", "Mableton", "Kennesaw", "Douglasville", "Tucker", "(CDP)", "Lawrenceville", "Duluth", "Griffin", "Carrollton", "Woodstock", "Canton", "Forest", "Park", "Flowery", "Branch", "Belvedere", "Park", "Newnan", "Snellville", "McDonough", "Acworth", "Cartersville", "Sugar", "Hill", "Union", "City", "Suwanee", "Powder", "Springs", "Riverdale", "Milton", "Fayetteville", "Covington", "Stockbridge", "Winder", "Conyers", "Monroe", "Vinings", "Lilburn", "Buford", "Chamblee", "Fairburn", "Norcross", "Doraville", "Clarkston", "Stone", "Mountain", "Austell", "Cumming", "Morrow", "Hampton", "Mill", "Dacula", "Jonesboro", "Lake", "City", "Lovejoy", "Loganville", "Lithonia"].each do |name|
   if Neighborhood.first(:conditions => ["name = ?", name])
     puts "----------------------Neighborhood (#{name}) already exists-------------------"
   else
     Neighborhood.create(:name => name ,:city_id => @city1.id)     
     puts "----------------------Neighborhood (#{name}) has been created-------------------"
   end
 end    
@city2 = City.first(:conditions => ["name = ?", "Atlanta (inside the perimeter)"])
["Ansley", "Park", "Brookhaven", "Cabbagetown", "Castleberry", "Hill", "Decatur", "Emory/Druid", "Hills", "Grant", "Park", "Inman", "Park", "Little", "Five", "points", "Morningside", "Old", "Fourth", "Ward", "Buckhead", "East", "Atlanta", "Midtown", "Downtown", "Virginia-Highlands", "West", "side", "Peachtree", "Battle"].each do |name| 
  if Neighborhood.first(:conditions => ["name = ?", name])
     puts "----------------------Neighborhood (#{name}) already exists-------------------"
   else
     Neighborhood.create(:name => name ,:city_id => @city2.id)     
     puts "----------------------Neighborhood (#{name}) has been created-------------------"
   end

end

["Moving sale","Estate sale","Furniture","Kitchen/cooking goods","Children's clothes/toys","Children's furniture","Antiques","Home decor","Sample sale","Men's/women's clothing","Artwork","Electronics","Jewelry","China/Crystal","Holiday decor","Books","Exercise equipment"].each do |name|
  if Category.first(:conditions => ["name = ?", name])
    puts "----------------------Category (#{name}) already exists-------------------"
  else
    Category.create(:name => name )
    puts "----------------------Category (#{name}) has been created-------------------"
  end
end  


@shipping_term = ShippingTerm.find(:first)
unless @shipping_term
  ShippingTerm.create(:featured_item_cost => 0,:featured_item_bidding_cost => 0)
end  