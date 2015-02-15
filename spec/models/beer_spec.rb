require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "has name and style set correctly" do
    style = FactoryGirl.create(:style)
    beer = Beer.create name:"Nobelaner"

    style.beers << beer

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    style = FactoryGirl.create(:style)
    beer = style.beers.create name:nil

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Nobelaner"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  describe "when one beer exists" do
    let(:beer){FactoryGirl.create(:beer)}

    it "is valid" do
      expect(beer).to be_valid
    end

    it "has the default style" do
      expect(beer.style.name).to eq("Lager")
    end
  end
end
