class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true}
  validate :brewery_cannot_be_established_in_the_future

  def brewery_cannot_be_established_in_the_future
    if self.year > Date.today.year
      errors.add(:year, "can't be after #{Date.today.year}!")
    end
  end

  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end
end
