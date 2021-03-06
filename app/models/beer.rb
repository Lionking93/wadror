class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style_id, presence: true

  def self.top(n)
    sorted_by_ratings_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
    top_n = sorted_by_ratings_in_desc_order[0..(n-1)]
  end

  def to_s
    "#{self.name}, #{self.brewery.name}"
  end

end
