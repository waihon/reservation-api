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
    end
  end
end