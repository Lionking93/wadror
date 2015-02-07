require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "has name and style set correctly" do
    beer = Beer.create name:"Nobelaner", style:"Lager"

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style:"Lager"

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
      expect(beer.style).to eq("Lager")
    end
  end
end
