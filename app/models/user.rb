class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4 }
  validates :password, format: { with: /(?=.*\d)(?=.*[A-Z])/, message: "must contain at least one capital letter and one number!"}

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def self.top(n)
    sorted_by_number_of_ratings_desc = User.all.sort_by{ |u| -(u.ratings.count) }
    top_n = sorted_by_number_of_ratings_desc[0..(n-1)]
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    beers_and_ratings_joined = Style.joins(:ratings).where("ratings.user_id = #{id}")
    styles_with_scores = beers_and_ratings_joined.select("styles.name as style, avg(score) as total_score").group("style")
    styles_with_scores.sort_by{|style| style.total_score}.last.style
  end

  def favorite_brewery
    return nil if ratings.empty?
    breweries_and_ratings_joined = Brewery.joins(:ratings).where("ratings.user_id = #{id}")
    breweries_and_scores = breweries_and_ratings_joined.select("breweries.name, avg(score) as total_score").group("breweries.name")
    breweries_and_scores.sort_by{|brewery| brewery.total_score}.last.name
  end
end
