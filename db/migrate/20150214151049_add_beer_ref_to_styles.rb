class AddBeerRefToStyles < ActiveRecord::Migration
  def change
    add_reference :styles, :beer, index: true
    add_foreign_key :styles, :beers
  end
end
