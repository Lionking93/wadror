class RemoveUserRefFromStyles < ActiveRecord::Migration
  def change
    remove_reference :styles, :user, index: true
    remove_foreign_key :styles, :users
  end
end
