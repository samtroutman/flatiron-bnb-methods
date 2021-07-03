class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_and_host_not_the_same, :check_availability, :checkout_after_checkin

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private
  def guest_and_host_not_the_same
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def check_availability
    # query = "select * from reservations where listing_id = #{self.id} AND '#{self.checkin}' between checkin AND checkout AND '#{self.checkout}' between checkin AND checkout"
    # return errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.") if Reservation.find_by_sql(query).size > 0
    # return true
  end

  def checkout_after_checkin
    if self.checkout && self.checkin
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Your checkin date needs to be after your checkout date")
      end
    end
  end

end
