class Dock
  attr_reader :name, :max_rental_time, :rental_log, :revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def log_hour
    @rental_log.each do |boat, renter|
      boat.add_hour
    end
  end

  def return(boat)
    @revenue += charge(boat)[:amount]
    @rental_log.delete(boat)
  end

  def charge(boat)
    card_and_ammount = {}
    card_and_ammount[:card_number] = @rental_log[boat].credit_card_number
    card_and_ammount[:amount] = total_by_boat(boat)
    card_and_ammount
  end

  def total_by_boat(boat)
    boat.price_per_hour * boat.hours_rented
  end

end
