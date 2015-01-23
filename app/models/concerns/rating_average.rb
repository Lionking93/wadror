module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    scoret = self.ratings.map {|rating| rating.score}
    rsumma = scoret.inject {|memo, lisattava| memo + lisattava}
    avg = rsumma.to_f / scoret.count
  end
end