class Topic < ActiveRecord::Base
  belongs_to :trip
  has_many :suggestions
end