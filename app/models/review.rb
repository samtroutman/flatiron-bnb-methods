class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation_id

  validate :reservation_exists_and_accepted_hasnt_happened_yet

  private
  def reservation_exists_and_accepted_hasnt_happened_yet
    errors.add(:reservation_id, "doesn't exist") unless Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Date.today
  end

end
