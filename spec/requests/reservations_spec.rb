require 'rails_helper'

RSpec.describe 'Reservations API', type: :request do
  describe "POST /reservations" do
    context "using payload #1" do
      let(:valid_reservation) do
        {
          "reservation_code": "YYY12345679",
          "start_date": "2021-04-20",
          "end_date": "2021-04-23",
          "nights": "3",
          "guests": 5,
          "adults": 3,
          "children": 1,
          "infants": 1,
          "status": "accepted",
          "guest": {
            "first_name": "Joe",
            "last_name": "Doe",
            "phone": "639123456789",
            "email": "joedoe@example.com"
          },
          "currency": "AUD",
          "payout_price": "4200.00",
          "security_price": "500",
          "total_price": "4700.00"
        }
      end

      let(:reservation_with_missing_params) do
        valid_reservation.except(:start_date, :nights, :status)
      end

      let(:reservation_without_guest_email) do
        guest_without_email = valid_reservation[:guest].except(:email)
        valid_reservation.merge({ guest: guest_without_email })
      end

      let(:reservation_without_code) do
        valid_reservation.except(:reservation_code)
      end

      let(:reservation_with_blank_email) do
        blank_email = { email: "" }
        guest_with_blank_email = valid_reservation[:guest].merge(blank_email)
        valid_reservation.merge({ guest: guest_with_blank_email })
      end

      let(:reservation_with_blank_code) do
        blank_reservation_code = { reservation_code: "" }
        valid_reservation.merge(blank_reservation_code)
      end

      let(:reservation_with_invalid_date) do
        invalid_date = { start_date: "Twenty Fifth" }
        valid_reservation.merge(invalid_date)
      end

      let(:reservation_with_invalid_integer) do
        invalid_integer = { nights: "Five" }
        valid_reservation.merge(invalid_integer)
      end

      let(:reservation_with_invalid_float) do
        invalid_float = { payout_price: "Two thousand five hundred" }
        valid_reservation.merge(invalid_float)
      end

      let(:changed_reservation) do
        valid_reservation.merge(
          {
            "start_date": "2021-04-22",
            "end_date": "2021-04-25",
            "guests": 6,
            "children": 2
          }
        )
      end

      let(:reservation_with_new_email) do
        new_email = { email: "newemail@example.com" }
        new_guest = valid_reservation[:guest].merge(new_email)
        valid_reservation.merge(guest: new_guest)
      end

      context "when valid parameters are provided for a new guest and a new reservation" do
        subject { post "/reservations", params: valid_reservation }

        it "should have status code 201" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should create a new guest" do
          expect { subject }.to change(Guest, :count).by(1)
        end

        it "should create a new reservation" do
          expect { subject }.to change(Reservation, :count).by(1)
        end

        it "should associate the new guest with the new reservation" do
          subject

          guest = Guest.find_by(email: "joedoe@example.com")
          reservation = Reservation.find_by(reservation_code: "YYY12345679")

          expect(reservation.guest).to eq(guest)
        end
      end

      context "when valid parameters are provided for an existing guest and an existing reservation" do
        before do
          post "/reservations", params: valid_reservation
        end

        subject { post "/reservations", params: changed_reservation }

        it "should return status code 200" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should not create any new guest" do
          expect { subject }.not_to change(Guest, :count)
        end

        it "should not create any new reservation" do
          expect { subject }.not_to change(Reservation, :count)
        end

        it "should accept changes to reservation" do
          # Before the changes
          reservation = Reservation.last
          expect(reservation.reservation_code).to eq("YYY12345679")
          expect(reservation.start_date).to eq(Date.parse("2021-04-20"))
          expect(reservation.end_date).to eq(Date.parse("2021-04-23"))
          expect(reservation.guests).to eq(5)
          expect(reservation.children).to eq(1)

          subject

          # After the changes
          reservation = Reservation.last
          expect(reservation.reservation_code).to eq("YYY12345679")
          expect(reservation.start_date).to eq(Date.parse("2021-04-22"))
          expect(reservation.end_date).to eq(Date.parse("2021-04-25"))
          expect(reservation.guests).to eq(6)
          expect(reservation.children).to eq(2)
        end

        it "should maintain the association between the existing guest and reservation" do
          guest = Guest.find_by(email: "joedoe@example.com")
          reservation = Reservation.find_by(reservation_code: "YYY12345679")

          expect(reservation.guest).to eq(guest)
        end
      end

      context "when valid parameters are provided for an existing guest but a new reservation" do
        before do
          guest = build(:guest, email: "joedoe@example.com")
          guest.save
        end

        subject { post "/reservations", params: valid_reservation }

        it "should return status code 201" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should not create any guest" do
          expect { subject }.not_to change(Guest, :count)
        end

        it "should create a new reservation" do
          expect { subject }.to change(Reservation, :count).by(1)
        end

        it "should associate the existing guest with the nerw reservation" do
          subject
          guest = Guest.find_by(email: "joedoe@example.com")
          reservation = Reservation.find_by(reservation_code: "YYY12345679")

          expect(reservation.guest).to eq(guest)
        end
      end

      context "when valid parameters are provided for a new guest but an existing reservation" do
        before do
          post "/reservations", params: valid_reservation
        end

        subject { post "/reservations", params: reservation_with_new_email }

        it "should return status code 200" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should create a new guest" do
          expect { subject }.to change(Guest, :count).by(1)
        end

        it "should not create any reservation" do
          expect { subject }.not_to change(Reservation, :count)
        end

        it "should associate the new guest with the existing reservation" do
          subject
          guest = Guest.find_by(email: "newemail@example.com")
          reservation = Reservation.find_by(reservation_code: "YYY12345679")

          expect(reservation.guest).to eq(guest)
        end
      end

      context "when required parameters are not provided" do
        subject { post "/reservations", params: reservation_with_missing_params }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Start date can't be blank/)
          expect(response.body).to match(/Nights can't be blank/)
          expect(response.body).to match(/Status can't be blank/)
        end
      end

      context "when guest email is not provided" do
        subject { post "/reservations", params: reservation_without_guest_email }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Invalid payload format/)
        end
      end

      context "when guest email is blank" do
        subject { post "/reservations", params: reservation_with_blank_email }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Email cannot be blank/)
        end
      end

      context "when reservation code is not provided" do
        subject { post "/reservations", params: reservation_without_code }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Invalid payload format/)
        end
      end

      context "when reservation code is blank" do
        subject { post "/reservations", params: reservation_with_blank_code }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Reservation code cannot be blank/)
        end
      end

      context "when start date is invalid" do
        subject { post "/reservations", params: reservation_with_invalid_date }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Start date must be a valid date/)
        end
      end

      context "when nights is invalid" do
        subject { post "/reservations", params: reservation_with_invalid_integer }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Nights must be a valid number/)
        end
      end

      context "when payout price is invalid" do
        subject { post "/reservations", params: reservation_with_invalid_float }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Payout price must be a valid monetary value/)
        end
      end
    end

    context "using payload #2" do
      let(:valid_reservation) do
        {
          "reservation": {
            "code": "XXX12345678",
            "start_date": "2021-03-12",
            "end_date": "2021-03-16",
            "expected_payout_amount": "3800.00",
            "guest_details": {
              "localized_description": "4 guests",
              "number_of_adults": 2,
              "number_of_children": 2,
              "number_of_infants": 0
            },
            "guest_email": "maryjane@example.com",
            "guest_first_name": "Mary",
            "guest_last_name": "Jane",
            "guest_phone_numbers": [
              "639123456789",
              "639123456789"
            ],
            "listing_security_price_accurate": "500.00",
            "host_currency": "AUD",
            "nights": 4,
            "number_of_guests": 4,
            "status_type": "accepted",
            "total_paid_amount_accurate": "4300.00"
          }
        }
      end

      let(:reservation_with_missing_params) do
        reservation = valid_reservation[:reservation].except(:end_date, :number_of_guests, :expected_payout_amount)
        {
          reservation: reservation
        }
      end

      let(:reservation_without_guest_email) do
        reservation = valid_reservation[:reservation].except(:guest_email)
        {
          reservation: reservation
        }
      end

      let(:reservation_without_code) do
        reservation = valid_reservation[:reservation].except(:code)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_blank_email) do
        blank_email = { guest_email: "" }
        reservation = valid_reservation[:reservation].merge(blank_email)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_blank_code) do
        blank_code = { code: "" }
        reservation = valid_reservation[:reservation].merge(blank_code)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_invalid_date) do
        invalid_date = { end_date: "Twenty Fifth" }
        reservation = valid_reservation[:reservation].merge(invalid_date)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_invalid_integer) do
        invalid_integer = { number_of_guests: "Four"}
        reservation = valid_reservation[:reservation].merge(invalid_integer)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_invalid_float) do
        invalid_float = { listing_security_price_accurate: "Five Hundred"}
        reservation = valid_reservation[:reservation].merge(invalid_float)
        {
          reservation: reservation
        }
      end

      let(:changed_reservation) do
        guest_details = valid_reservation.dig(:reservtion, :guest_details) || {}
        guest_details.merge!(
          {
            localized_description: "5 guests",
            number_of_infants: 1
          }
        )
        reservation = valid_reservation.dig(:reservation) || {}
        reservation.merge!(
          {
            end_date: "2021-03-18",
            nights: 6,
            number_of_guests: 5,
            guest_details: guest_details
          }
        )
        { reservation: reservation }
      end

      let(:reservation_with_new_email) do
        reservation = valid_reservation.dig(:reservation) || {}
        new_email = { guest_email: "newemail@example.com" }
        reservation.merge!(new_email)
        { reservation: reservation }
      end

      context "when valid parameters are provided for a new guest and a new reservation" do
        subject { post "/reservations", params: valid_reservation }

        it "should have status code 201" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should create a new guest" do
          expect { subject }.to change(Guest, :count).by(1)
        end

        it "should create a new reservation" do
          expect { subject }.to change(Reservation, :count).by(1)
        end
      end

      context "when valid parameters are provided for an existing guest and an existing reservation" do
        before do
          post "/reservations", params: valid_reservation
        end

        subject { post "/reservations", params: changed_reservation }

        it "should return status code 200" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should not create any new guest" do
          expect { subject }.not_to change(Guest, :count)
        end

        it "should not create any new reservation" do
          expect { subject }.not_to change(Reservation, :count)
        end

        it "should accept changes to reservation" do
          # Before the changes
          reservation = Reservation.last
          expect(reservation.reservation_code).to eq("XXX12345678")
          expect(reservation.end_date).to eq(Date.parse("2021-03-16"))
          expect(reservation.nights).to eq(4)
          expect(reservation.guests).to eq(4)
          expect(reservation.localized_description).to eq("4 guests")
          expect(reservation.infants).to eq(0)

          subject

          # After the changes
          reservation = Reservation.last
          expect(reservation.reservation_code).to eq("XXX12345678")
          expect(reservation.end_date).to eq(Date.parse("2021-03-18"))
          expect(reservation.nights).to eq(6)
          expect(reservation.guests).to eq(5)
          expect(reservation.localized_description).to eq("5 guests")
          expect(reservation.infants).to eq(1)
        end

        it "should maintain the association between the existing guest and reservation" do
          guest = Guest.find_by(email: "maryjane@example.com")
          reservation = Reservation.find_by(reservation_code: "XXX12345678")

          expect(reservation.guest).to eq(guest)
        end
      end

      context "when valid parameters are provided for an existing guest but a new reservation" do
        before do
          guest = build(:guest, email: "maryjane@example.com")
          guest.save
        end

        subject { post "/reservations", params: valid_reservation }

        it "should return status code 201" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should not create any guest" do
          expect { subject }.not_to change(Guest, :count)
        end

        it "should create a new reservation" do
          expect { subject }.to change(Reservation, :count).by(1)
        end

        it "should associate the existing guest with the nerw reservation" do
          subject
          guest = Guest.find_by(email: "maryjane@example.com")
          reservation = Reservation.find_by(reservation_code: "XXX12345678")

          expect(reservation.guest).to eq(guest)
        end
      end

      context "when valid parameters are provided for a new guest but an existing reservation" do
        before do
          post "/reservations", params: valid_reservation
        end

        subject { post "/reservations", params: reservation_with_new_email }

        it "should return status code 200" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "should create a new guest" do
          expect { subject }.to change(Guest, :count).by(1)
        end

        it "should not create any reservation" do
          expect { subject }.not_to change(Reservation, :count)
        end

        it "should associate the new guest with the existing reservation" do
          subject
          guest = Guest.find_by(email: "newemail@example.com")
          reservation = Reservation.find_by(reservation_code: "XXX12345678")

          expect(reservation.guest).to eq(guest)
        end
      end

      context "when required parameters are not provided" do
        subject { post "/reservations", params: reservation_with_missing_params }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/End date can't be blank/)
          expect(response.body).to match(/Guests can't be blank/)
          expect(response.body).to match(/Payout price can't be blank/)
        end
      end

      context "when guest email is not provided" do
        subject { post "/reservations", params: reservation_without_guest_email }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Invalid payload format/)
        end
      end

      context "when reservation code is not provided" do
        subject { post "/reservations", params: reservation_without_code }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Invalid payload format/)
        end
      end

      context "when guest email is blank" do
        subject { post "/reservations", params: reservation_with_blank_email }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Email cannot be blank/)
        end
      end

      context "when reservation code is blank" do
        subject { post "/reservations", params: reservation_with_blank_code }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Reservation code cannot be blank/)
        end
      end

      context "when end date is invalid" do
        subject { post "/reservations", params: reservation_with_invalid_date }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/End date must be a valid date/)
        end
      end

      context "when guests is invalid" do
        subject { post "/reservations", params: reservation_with_invalid_integer }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Guests must be a valid number/)
        end
      end

      context "when security price is invalid" do
        subject { post "/reservations", params: reservation_with_invalid_float }

        it "should return status code 422" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return validation failure messages" do
          subject
          expect(response.body).to match(/Security price must be a valid monetary value/)
        end
      end
    end
  end
end
