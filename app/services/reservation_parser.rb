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
    # the registry. Such subclassess will somehow have to be in the same
    # source file as the base class for the inherited hook to work.
    register(candidate)
  end

  def self.handles?(params)
    # This parser handles the payload which includes reservation_code
    # and email.
    # !! are used to convert to logical expressions.
    !!params.dig(:reservation_code) && !!params.dig(:email)
  end

  def reservation_variables
    # This parser uses instance variables with the same name as that
    # of the payload.
    # This method may need to be overriden by a child parser for
    # additional fields and/or fields not found in the base parser.
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

  def reservation_params
    # This parser uses parameters with the same name as that of the
    # instance variables.
    # This method may need to be overriden by a child parser for payloads
    # with different parameters.
    reservation_variables
  end

  def initialize(params)
    @params = params
  end

  def map_params_to_variables
    # This method assigns param values to normalized instance variables
    # which will be used in downstream parsing.
    reservation_variables.zip(reservation_params) do |variable, param|
      # E.g. @reservation_code = params.dig("reservation_code")
      instance_variable_set("@" + variable, params.dig(param))
    end
  end

  def parse
    # This method contains the main parsing logic and uses the template
    # design pattern.
    # It may not need to be overriden by a child parser.
    map_params_to_variables

    # Guest email field should be unique based on the requirement.
    # When an email is not found, we create a new guest object, eelse
    # to update an existing one.
    # @email is populated in the map_params_to_variables method.
    @guest = Guest.find_by(email: @email) || Guest.new
    update_guest

    # Reservation code field should be unique based on the requirement.
    # When a reservation code is not found, we cerate a new reservation
    # object, elease to update an existing one.
    # @reservation_code is populated in the map_params_to_variables method.
    @reservation = Reservation.find_by(reservation_code: @reservation_code) || Reservation.new
    update_reservation

    # Return the populated guest and reservation model objects to the caller
    # for further processing.
    return @guest, @reservation
  end

  def update_guest
    # This method contains the parsing logic for the common fields of a guest
    # and may not need to be overriden by a child parser.
    begin
      guest.email = @email if @email.present?
      guest.first_name = @first_name if @first_name.present?
      guest.last_name = @last_name if @last_name.present?

      # If there's any guest fields specific to a payload, we should include
      # them in below hook.
      update_additional_guest_fields
    rescue => exception
      raise exception
    end
  end

  def update_additional_guest_fields
    # This method is for updating additional guest fields specific to a
    # payload format and needs to be overriden.
    guest.phone_1 = @phone if @phone.present?
  end

  def update_reservation
    # This method contains the parsing logic for the common fields of a
    # reservation and may not need to be overriden by a child parser.
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

      # If there's any reservation fields specific to a payload, we should
      # include them in below hook.
      update_additional_reservation_fields
    rescue => exception
      raise exception
    end
  end

  def update_additional_reservation_fields
    # This method is for updating additional reservation fields specific to
    # a payload format and needs to be overriden by a child parser.
    # There's no additional reservation fields for payload #1.
  end
end

# We'll need to include the subclasses in the same source file as the base
# class in order for the inherited hook to work (based on observation).
class ReservationParser2 < ReservationParser
  def self.handles?(params)
    # This parser handles payload #2 which includes code and guest_email.
    # !! are used to convert to logical expressions.
    !!params.dig(:code) && !!params.dig(:guest_email)
  end

  def reservation_variables
    # Payload #2 doesn't have phone but has 2 other fields not found in
    # payout #1.
    super - ["phone"] + ["phones", "localized_description"]
  end

  def reservation_params
    # This parser has enough parameters with differnt name from that of the
    # instance variables to warrant a separate declaration.
    [
      "code",
      "start_date",
      "end_date",
      "nights",
      "number_of_guests",
      "number_of_adults",
      "number_of_children",
      "number_of_infants",
      "status_type",
      "host_currency",
      "expected_payout_amount",
      "listing_security_price_accurate",
      "total_paid_amount_accurate",
      "guest_email",
      "guest_first_name",
      "guest_last_name",
      "guest_phone_numbers",
      "localized_description"
    ]
  end

  def update_additional_guest_fields
    # This method is for updating additional guest fields specific to
    # payload #2.
    begin
      @phones.take(3).each_with_index do |phone, index|
        # Populate phone_1, phone_2, and/or phone_3.
        # The index is zero-based so needs to increment by 1.
        guest.send("phone_#{index + 1}=", phone)
      end
    rescue => exception
      raise exception
    end
  end

  def update_additional_reservation_fields
    # This method is for updating additional reservation fields specific to
    # payload #2.
    begin
      reservation.localized_description = @localized_description if @localized_description.present?
    rescue => exception
      raise exception
    end
  end
end