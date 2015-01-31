module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    scoret = self.ratings.map {|rating| rating.score}
    return 0 if scoret.empty?
    avg = scoret.inject {|memo, lisattava| memo + lisattava}.to_f / scoret.count
  end
end