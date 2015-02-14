require 'rails_helper'

describe 'Places' do

  it 'if one is returned by the API, it is shown at the page' do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([ Place.new( name:"Oljenkorsi", id: 1) ])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    byebug
    expect(page).to have_content "Oljenkorsi"
  end

  it 'if multiple are returned with API, all are shown at the page' do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([ Place.new(name: "Oljenkorsi", id: 1), Place.new(name: "Oluthuone", id: 2) ])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button("Search")

    expect(page).to have_content("Oljenkorsi")
    expect(page).to have_content("Oluthuone")
  end

  it "if none are returned, page tells that no places at the chosen location" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: "kumpula")
    click_button("Search")

    expect(page).to have_content("No locations in kumpula")
    save_and_open_page
  end
end