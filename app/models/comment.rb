class Comment < ActiveRecord::Base
    belongs_to :sale
belongs_to :user
  validate :validate_body

  def validate_body
    if self.body.blank?
      self.errors.add(:comment," can't be blank.")
    end  
  end  
end

