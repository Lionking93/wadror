require 'rails_helper'

BeerClub
BeerClubsController
MembershipsController
RatingAverage

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
    expect(user.valid?).to be(true)
    expect(User.count).to eq(1)
  end

  it "and with two ratings, has the correct average rating" do
    user.ratings << FactoryGirl.create(:rating)
    user.ratings << FactoryGirl.create(:rating2)

    expect(user.ratings.count).to eq(2)
    expect(user.average_rating).to eq(15.0)
  end
  end

  it "does not have too short password" do
    user = User.create username:"Pekka", password:"St1", password_confirmation:"St1"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "does not have a password with only letters" do
    user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user, "Lager", "Koff")
      best = create_beer_with_rating(25, user, "Lager", "Koff")

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user)}

    it "has method for determining the favorite_style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings favorite_style returns nil" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with the highest average of ratings" do
      create_beer_with_rating(10, user, "Lager", "Koff")
      create_beer_with_rating(9, user, "Stout", "Koff")
      create_beer_with_rating(12, user, "Stout", "Koff")

      expect(user.favorite_style).to eq('Stout')
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user)}

    it "has method for determining the favorite_brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings returns nil" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only brewery if only one rating" do
      beer = create_beer_with_rating(10, user, "Lager", "Koff")
      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the brewery with the highest average of ratings" do
      create_beer_with_rating(10, user,"Lager", "Koff")
      create_beer_with_rating(9, user, "Lager", "BrewDog")
      create_beer_with_rating(12, user, "Lager", "BrewDog")

      expect(user.favorite_brewery).to eq("BrewDog")
    end
  end

  def create_beer_with_rating(score, user, style, brewery)
    brewery1 = FactoryGirl.create(:brewery, name: brewery)
    style1 = FactoryGirl.create(:style, name: style)
    beer = FactoryGirl.create(:beer, style:style1, brewery: brewery1)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user, style, brewery)
    scores.each do |score|
      create_beer_with_rating(score, user, style, brewery)
    end
  end
end
