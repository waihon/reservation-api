require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe "validation tests" do
    it "should validate the presence of email" do
      guest = build(:guest, email: "")
      guest.valid?
      expect(guest).not_to be_valid
      expect(guest.errors.messages[:email]).to include("can't be blank")
    end

    it "should validate the presence of first name" do
      guest = build(:guest, first_name: "")
      guest.valid?
      expect(guest).not_to be_valid
      expect(guest.errors.messages[:first_name]).to include("can't be blank")
    end

    it "should validate the presence of last name" do
      guest = build(:guest, last_name: "")
      guest.valid?
      expect(guest).not_to be_valid
      expect(guest.errors.messages[:last_name]).to include("can't be blank")
    end

    it "should validate the presence of phone #1" do
      guest = build(:guest, phone_1: "")
      guest.valid?
      expect(guest).not_to be_valid
      expect(guest.errors.messages[:phone_1]).to include("can't be blank")
    end

    it "email should be unique" do
      guest1 = build(:guest, email: "joedoe@example.com")
      guest1.valid?
      expect(guest1).to be_valid
      guest1.save

      guest2 = build(:guest, email: "joedoe@example.com")
      guest2.valid?
      expect(guest2.errors.messages[:email]).to include("has already been taken")
    end
  end

  describe "positive tests" do
    it "should be valid when built with the factory" do
      guest = build(:guest)
      guest.valid?
      
      expect(guest).to be_valid
    end
  end

  describe "association test" do
    it "should have a 1-to-many relationship with the Reservation model" do
      guest = build(:guest)
      reservation1 = build(:reservation, guest: guest)
      reservation1.save!
      reservation2 = build(:reservation, guest: guest)
      reservation2.save!
      reservation3 = build(:reservation, guest: guest)
      reservation3.save!
      
      expect(guest.reservations.count).to eq(3)
    end
  end
end