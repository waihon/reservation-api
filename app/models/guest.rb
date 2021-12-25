class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }
  validates_presence_of :email, :first_name, :last_name, :phone
end
