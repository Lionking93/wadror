require 'rails_helper'

RSpec.describe Brewery, type: :model do
  it "has the name and year set correctly and is saved to database" do
    brewery = Brewery.create name:"Schenkerla", year:1674

    expect(brewery.name).to eq("Schenkerla")
    expect(brewery.year).to eq(1674)
    expect(brewery).to be_valid
  end

  it "without name is not valid" do
    brewery = Brewery.create year:1674

    expect(brewery).not_to be_valid
  end
end
