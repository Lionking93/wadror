json.array!(@active_breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beers brewery.beers.count
end
json.array!(@retired_breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beers brewery.beers.count
end

