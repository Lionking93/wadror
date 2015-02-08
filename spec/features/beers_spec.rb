require 'rails_helper'

describe "Beer" do
  let!(:user){FactoryGirl.create :user}

  before :each do
    sign_in(username:'Pekka', password:'Foobar1')
  end

  it "when beer name given, is added to the system" do
    visit new_beer_path
    fill_in('beer_name', with: 'Bisse')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "when beer name is not given, is redirected to beer-creating page" do
    visit new_beer_path
    click_button "Create Beer"

    expect(current_path).to eq(beers_path)
    expect(page).to have_content("Name can't be blank")
    expect(Beer.count).to eq(0)
  end
end