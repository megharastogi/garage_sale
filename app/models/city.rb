class City < ActiveRecord::Base

  belongs_to :state
  has_many :neighborhoods
  has_many :sales
  
  validates_presence_of :name ,:state_id
  validates_inclusion_of :state_id, :in => State.all.collect {|c| c.id  }, :if => lambda{|t| !t.state.blank?}  
  
end
