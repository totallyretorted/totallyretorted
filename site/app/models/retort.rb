class Retort < ActiveRecord::Base
  has_one :attribution
  has_and_belongs_to_many :tags
  has_one :rating
end
