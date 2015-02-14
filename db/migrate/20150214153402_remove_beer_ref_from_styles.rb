class RemoveBeerRefFromStyles < ActiveRecord::Migration
  def change
    remove_reference :styles, :beer, index: true
    remove_foreign_key :styles, :beers
  end
end
