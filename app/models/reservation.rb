class Reservation < ApplicationRecord
  belongs_to :guest

  validates :reservation_code, uniqueness: { case_sensitive: false }
  validates_presence_of :reservation_code, :start_date, :end_date, :nights, :guests,
    :adults, :children, :infants, :status, :currency, :payout_price,
    :security_price, :total_price
end
