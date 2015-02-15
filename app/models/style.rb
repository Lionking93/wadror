class Style < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
end
