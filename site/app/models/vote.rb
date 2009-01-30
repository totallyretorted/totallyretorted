class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :retort
  
  # named_scope :find_by_retort, lambda{ |r|
  #     :conditions => {:retort => r}
  #   }
  
  
  named_scope :positive, :conditions => ["value >= 0"]
  
  named_scope :negative, :conditions => ["value <= 0"]
end
