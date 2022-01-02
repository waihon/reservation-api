class ReservationsController < ApplicationController
  def create
    begin
      # Call the parser base class to determine an appropriate paser which will
      # then parse the params and populate the attributes of both the guest and
      # reservation
      @guest, @reservation = ReservationParser.for(reservation_params).parse

      # Since the API endpoint can be used to accept changes to a reservation,
      # the status to be returned will depend on whether the reservation
      # is a new one or an existing one.
      status = @reservation.new_record? ? :created : :ok

      # The save method is called to create in the case of a new record or
      # update in the case of an existing record.
      if @guest.save
        if @reservation.save
          head status
        else
          render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: @guest.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => exception
      render json: { errors: [exception] }, status: :unprocessable_entity
    end
  end

private

  def reservation_params
    # Params for payload #1
    permitted_params = params.permit(:reservation_code, :start_date, :end_date, :nights, :guests, :adults,
      :children, :infants, :status, :currency, :payout_price, :security_price, :total_price)
    if params.dig(:guest)
      permitted_params = permitted_params.merge(params.require(:guest).permit(:email,
        :first_name, :last_name, :phone))
    end

    # Params for payload #2
    if params.dig(:reservation) 
      permitted_params = permitted_params.merge(params.require(:reservation).permit(:code,
        :start_date, :end_date, :nights, :number_of_guests, :status_type, :host_currency,
        :expected_payout_amount, :listing_security_price_accurate, :total_paid_amount_accurate,
        :guest_email, :guest_first_name, :guest_last_name, guest_phone_numbers: []))
    end
    if params.dig(:reservation, :guest_details)
      permitted_params = permitted_params.merge(params.require(:reservation).require(:guest_details)
        .permit(:number_of_adults, :number_of_children, :number_of_infants, :localized_description))
    end

    return permitted_params
  end
end
