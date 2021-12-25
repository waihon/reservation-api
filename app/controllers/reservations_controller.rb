class ReservationsController < ApplicationController
  def create
    begin
      @guest, @reservation = ReservationParser.for(reservation_params).parse

      status = @reservation.new_record? ? :created : :ok
      if @guest.save
        if @reservation.save
          render status: status
        else
          render json: { errors: @reservation.errors }, status: :unprocessable_entity
        end
      else
        render json: { errors: @guest.errors }, status: :unprocessable_entity
      end
    rescue => exception
      render json: { errors: [exception] }, status: :unprocessable_entity
    end
  end

private

  def reservation_params
    # For additional payload formats, we'll need to add parameters with
    # different name via merging.
    params.permit(:reservation_code, :start_date, :end_date, :nights, :guests, :adults,
      :children, :infants, :status, :currency, :payout_price, :security_price, :total_price)
      .merge(params.require(:guest).permit(:email, :first_name, :last_name, :phone))
  end
end
