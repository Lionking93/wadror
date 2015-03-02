require 'rails_helper'

describe "Beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name:"Koff")
    @brewery2 = FactoryGirl.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryGirl.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryGirl.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryGirl.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  describe "shows beers ordered by" do
    before :each do
      visit beerlist_path
      @first_beer = find('table').find('tr:nth-child(2)')
      @second_beer = find('table').find('tr:nth-child(3)')
      @third_beer = find('table').find('tr:nth-child(4)')
    end

  it "shows one known beer", js:true do
    expect(page).to have_content "Nikolai"
  end

  it "by name", js:true do
    expect(@first_beer).to have_content "Fastenbier"
    expect(@second_beer).to have_content "Lechte Weisse"
    expect(@third_beer).to have_content "Nikolai"
  end

  it "by style when style is clicked", js:true do
    click_link "Style"
    expect(@first_beer).to have_content "Lager"
    expect(@second_beer).to have_content "Rauchbier"
    expect(@third_beer).to have_content "Weizen"
  end

    it "by brewery when brewery is clicked", js:true do
      click_link "Brewery"
      expect(@first_beer).to have_content "Ayinger"
      expect(@second_beer).to have_content "Koff"
      expect(@third_beer).to have_content "Schlenkerla"
    end
    end
end