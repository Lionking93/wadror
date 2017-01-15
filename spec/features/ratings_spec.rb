require 'rails_helper'

describe "Rating" do
  let!(:brewery) {FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) {FactoryGirl.create :beer, name:"iso 3", brewery:brewery}
  let!(:beer2) {FactoryGirl.create :beer, name:"Karhu", brewery:brewery}
  let!(:user) {FactoryGirl.create :user}

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

  expect(user.ratings.count).to eq(1)
  expect(beer1.ratings.count).to eq(1)
  expect(beer1.average_rating).to eq(15.0)
  end

  describe "Ratings" do
    before :each do
      user2 = FactoryGirl.create :user, username: "Rokka", password:"Abc123", password_confirmation:"Abc123"
      rating1 = FactoryGirl.create :rating
      rating2 = FactoryGirl.create :rating2
      beer1.ratings << rating1
      beer1.ratings << rating2
      user.ratings << rating1
      user2.ratings << rating2
    end

    it "that a user has given and the amount of them are shown on the user's page" do
    visit user_path(user)

    expect(page).to have_content("iso 3 10")
    expect(page).not_to have_content("iso 3 20")
    end

    it "are removed from database if user removes them" do
      rating3 = FactoryGirl.create(:rating, score:15)
      beer2.ratings << rating3
      user.ratings << rating3

      visit user_path(user)

      page.first('li', :text => 'delete').click_link('delete')
      expect(Rating.count).to eq(2)
      expect(user.ratings.count).to eq(1)
    end
  end
end