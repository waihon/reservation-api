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
        valid_reservation.except(:guest).merge(guest_without_email)
      end

      let(:reservation_without_code) do
        valid_reservation.except(:reservation_code)
      end

      let(:reservation_with_blank_email) do
        guest_without_email = valid_reservation[:guest].except(:email)
        blank_email = { email: "" }
        updated_guest = { guest: guest_without_email.merge(blank_email) }
        valid_reservation.except(:guest).merge(updated_guest)
      end

      let(:reservation_with_blank_code) do
        blank_reservation_code = { reservation_code: "" }
        valid_reservation.except(:reservation_code).merge(blank_reservation_code)
      end

      let(:reservation_with_invalid_date) do
        invalid_date = { start_date: "Twenty Fifth"}
        valid_reservation.except(:start_date).merge(invalid_date)
      end

      let(:reservation_with_invalid_integer) do
        invalid_integer = { nights: "Five"}
        valid_reservation.except(:nights).merge(invalid_integer)
      end

      let(:reservation_with_invalid_float) do
        invalid_float = { payout_price: "Two thousand five hundred"}
        valid_reservation.except(:payout_price).merge(invalid_float)
      end

      context "when valid parameters are provided" do
        subject { post "/reservations", params: valid_reservation }

        it "should have status code 201" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should create the guest" do
          expect { subject }.to change(Guest, :count).by(1)
        end

        it "should create the reservation" do
          expect { subject }.to change(Reservation, :count).by(1)
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
        reservation = valid_reservation[:reservation].except(:guest_email).merge(blank_email)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_blank_code) do
        blank_code = { code: "" }
        reservation = valid_reservation[:reservation].except(:code).merge(blank_code)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_invalid_date) do
        invalid_date = { end_date: "Twenty Fifth"}
        reservation = valid_reservation[:reservation].except(:end_date).merge(invalid_date)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_invalid_integer) do
        invalid_integer = { number_of_guests: "Four"}
        reservation = valid_reservation[:reservation].except(:number_of_guests).merge(invalid_integer)
        {
          reservation: reservation
        }
      end

      let(:reservation_with_invalid_float) do
        invalid_float = { listing_security_price_accurate: "Five Hundred"}
        reservation = valid_reservation[:reservation].except(:listing_security_price_accurate).merge(invalid_float)
        {
          reservation: reservation
        }
      end

      context "when valid parameters are provided" do
        subject { post "/reservations", params: valid_reservation }

        it "should have status code 201" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should create the guest" do
          expect { subject }.to change(Guest, :count).by(1)
        end

        it "should create the reservation" do
          expect { subject }.to change(Reservation, :count).by(1)
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
