class ReservationParser
  attr_reader :params, :guest, :reservation

  def self.for(params)
    # A factory method that returns an approprite parser for the
    # payload format.
    registry.find do |candidate|
      candidate.handles?(params)
    end.new(params)
  end

  def self.registry
    # The superclass itself won't get automatically registered via
    # the inherited hook so we'll need to ensure that it will.
    @registry ||= [ReservationParser]
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  def self.inherited(candidate)
    # Subclasses that inherit from this base parser will be added to
    # the registry.
    register(candidate)
  end

  def self.handles?(params)
    # This parser handles the payload which includes reservation_code
    # and email.
    # !! are used to convert to logical expressions.
    !!params.dig(:reservation_code) && !!params.dig(:email)
  end

  def self.reservation_variables
    # This parser uses instance variables with the same name as that
    # of the payload.
    # This method may not need to be overriden for an alternative parser.
    [
      "reservation_code",
      "start_date",
      "end_date",
      "nights",
      "guests",
      "adults",
      "children",
      "infants",
      "status",
      "currency",
      "payout_price",
      "security_price",
      "total_price",
      "email",
      "first_name",
      "last_name",
      "phone"
    ]
  end

  def self.reservation_params
    # This parser uses parameters with the same name as that of the
    # instance variables.
    # This method may need to be overriden for an alternative parser
    # with different parameters.
    self.reservation_variables
  end

  def initialize(params)
    @params = params
  end

  def map_params_to_variables
    # This method assigns param values to normalized instance variables
    # which will be used in downstream parsing.
    self.class.reservation_variables.zip(self.class.reservation_params) do |variable, param|
      # E.g. @reservation_code = params.dig("reservation_code")
      instance_variable_set("@" + variable, params.dig(param))
    end
  end

  def parse
    # This method contains the main parsing logic and may not need to be
    # overriden for an alternative parser.
    map_params_to_variables

    @guest = Guest.find_by(email: @email) || Guest.new
    update_guest

    @reservation = Reservation.find_by(reservation_code: @reservation_code) || Reservation.new
    update_reservation

    return @guest, @reservation
  end

  def update_guest
    # This method contains the parsing logic for a guest and may need to be
    # overriden for an alternative parser.
    begin
      guest.email = @email if @email.present?
      guest.first_name = @first_name if @first_name.present?
      guest.last_name = @last_name if @last_name.present?
      guest.phone = @phone if @phone.present?
    rescue => exception
      raise exception  
    end
  end

  def update_reservation
    # This method contains the parsing logic for a reservation and may need
    # to be overriden for an alternative parser.
    begin
      reservation.reservation_code = @reservation_code if @reservation_code.present?
      reservation.start_date = Date.parse(@start_date) if @start_date.present?
      reservation.end_date = Date.parse(@end_date) if @end_date.present?
      reservation.nights = Integer(@nights) if @nights.present?
      reservation.guests = Integer(@guests) if @guests.present?
      reservation.adults = Integer(@adults) if @adults.present?
      reservation.children = Integer(@children) if @children.present? 
      reservation.infants = Integer(@infants) if @infants.present?
      reservation.status = @status if @status.present?
      reservation.currency = @currency if @currency.present?
      reservation.payout_price = @payout_price.to_f if @payout_price.present?
      reservation.security_price = @security_price.to_f if @security_price.present?
      reservation.total_price = @total_price.to_f if @total_price.present?
      reservation.guest = guest
    rescue => exception
      raise exception  
    end
  end
end