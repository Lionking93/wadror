class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_ratings_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating||0) }
    top_n = sorted_by_ratings_in_desc_order[0..(n-1)]
  end
end
