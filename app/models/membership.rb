class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validate :user_is_not_member_of_club

  def user_is_not_member_of_club
      Membership.all.each do |membership|
        if membership.user_id == self.user_id and membership.beer_club_id == self.beer_club_id
          errors.add(:user, "is already a member of this club!")
        end
      end
  end
end
