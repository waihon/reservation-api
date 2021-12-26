class Reservation < ApplicationRecord
  belongs_to :guest

  validates :reservation_code, uniqueness: { case_sensitive: false }
  validates_presence_of :reservation_code, :start_date, :end_date, :nights, :guests,
    :adults, :children, :infants, :status, :currency, :payout_price,
    :security_price, :total_price
  validates :nights, :guests, :adults, :children, :infants, numericality: { greater_than_or_equal_to: 0 }
  validates :payout_price, :security_price, :total_price, numericality: { greater_than_or_equal_to: 0 }
end
