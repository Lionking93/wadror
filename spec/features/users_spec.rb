require 'rails_helper'

describe "User" do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      visit signin_path
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
      puts page.html
    end

    it "when signed in and has no ratings, doesn't have any favorites" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content("Doesn't have a favorite beer yet!")
      expect(page).to have_content("Doesn't have a favorite style yet!")
      expect(page).to have_content("Doesn't have a favorite brewery yet!")
    end

    describe "sees when signed in" do
      before :each do
        create_beer_with_rating_style_and_brewery(10, @user, "Iso 3", "Lager", "Koff")
        create_beer_with_rating_style_and_brewery(18, @user, "Karhu", "Stout", "Koff")
        create_beer_with_rating_style_and_brewery(13, @user, "Iso 3", "Stout", "Malmgard")
        sign_in(username:"Pekka", password:"Foobar1")
      end

      it "the name of his favorite beer on his page" do
        expect(page).to have_content("Favorite beer is Karhu")
      end

      it "his favorite beer style" do
        expect(page).to have_content("Favorite style is Stout")
      end

      it "his favorite brewery" do
        expect(page).to have_content("Favorite brewery is Koff")
      end
      end
  end

  def create_beer_with_rating_style_and_brewery(score, user, name, style, brewery)
    brewery1 = FactoryGirl.create(:brewery, name: brewery)
    beer = FactoryGirl.create(:beer, name:name, style:style, brewery: brewery1)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end
end