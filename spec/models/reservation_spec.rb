require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "validation tests" do
    it "should validate the presence of reservation code" do
      reservation = build(:reservation, reservation_code: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:reservation_code]).to include("can't be blank")
    end

    it "should validate the presence of start date" do
      reservation = build(:reservation, start_date: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:start_date]).to include("can't be blank")
    end

    it "should validate the presence of end date" do
      reservation = build(:reservation, end_date: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:end_date]).to include("can't be blank")
    end

    it "should validate the presence of nights" do
      reservation = build(:reservation, nights: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:nights]).to include("can't be blank")
    end

    it "should validate the presence of guests" do
      reservation = build(:reservation, guests: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:guests]).to include("can't be blank")
    end

    it "should validate the presence of adults" do
      reservation = build(:reservation, adults: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:adults]).to include("can't be blank")
    end

    it "should validate the presence of children" do
      reservation = build(:reservation, children: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:children]).to include("can't be blank")
    end

    it "should validate the presence of infants" do
      reservation = build(:reservation, infants: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:infants]).to include("can't be blank")
    end

    it "should validate the presence of status" do
      reservation = build(:reservation, status: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:status]).to include("can't be blank")
    end

    it "should validate the presence of currency" do
      reservation = build(:reservation, currency: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:currency]).to include("can't be blank")
    end

    it "should validate the presence of payout price" do
      reservation = build(:reservation, payout_price: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:payout_price]).to include("can't be blank")
    end

    it "should validate the presence of security price" do
      reservation = build(:reservation, security_price: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:security_price]).to include("can't be blank")
    end

    it "should validate the presence of total price" do
      reservation = build(:reservation, total_price: "")
      reservation.valid?
      expect(reservation).not_to be_valid
      expect(reservation.errors.messages[:total_price]).to include("can't be blank")
    end

    it "reservation code should be unique" do
      reservation1 = build(:reservation, reservation_code: "YYY12345678")
      reservation1.valid?
      expect(reservation1).to be_valid
      reservation1.save

      reservation2 = build(:reservation, reservation_code: "YYY12345678")
      reservation2.valid?
      expect(reservation2.errors.messages[:reservation_code]).to include("has already been taken")
    end

    it "nights should be greater than or equal to 0" do
      reservation = build(:reservation, nights: -1)
      reservation.valid?

      expect(reservation.errors.messages[:nights]).to include("must be greater than or equal to 0")
    end

    it "guests should be greater than or equal to 0" do
      reservation = build(:reservation, guests: -1)
      reservation.valid?

      expect(reservation.errors.messages[:guests]).to include("must be greater than or equal to 0")
    end

    it "adults should be greater than or equal to 0" do
      reservation = build(:reservation, adults: -1)
      reservation.valid?

      expect(reservation.errors.messages[:adults]).to include("must be greater than or equal to 0")
    end

    it "children should be greater than or equal to 0" do
      reservation = build(:reservation, children: -1)
      reservation.valid?

      expect(reservation.errors.messages[:children]).to include("must be greater than or equal to 0")
    end

    it "infants should be greater than or equal to 0" do
      reservation = build(:reservation, infants: -1)
      reservation.valid?

      expect(reservation.errors.messages[:infants]).to include("must be greater than or equal to 0")
    end

    it "payout price should be greater than or equal to 0" do
      reservation = build(:reservation, payout_price: -1.23)
      reservation.valid?

      expect(reservation.errors.messages[:payout_price]).to include("must be greater than or equal to 0")
    end

    it "security price should be greater than or equal to 0" do
      reservation = build(:reservation, security_price: -1.23)
      reservation.valid?

      expect(reservation.errors.messages[:security_price]).to include("must be greater than or equal to 0")
    end

    it "total price should be greater than or equal to 0" do
      reservation = build(:reservation, total_price: -1.23)
      reservation.valid?

      expect(reservation.errors.messages[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe "positive tests" do
    it "should be valid when built with the factory" do
      reservation = build(:reservation)
      reservation.valid?
      
      expect(reservation).to be_valid
    end
  end

  describe "association test" do
    it "should belong to the Guest model" do
      guest = build(:guest)
      reservation = build(:reservation, guest: guest)

      expect(reservation.guest).to eq(guest)
    end
  end
end