class PassengerWagon < Wagon
  def initialize(seats_count)
    @type = :passenger
    @seats = {}
    create_seats(seats_count)
  end

  def take_seat
    @empty_seat = @seats.key(nil)
    raise 'В вагоне закончились свободные места' if @empty_seat.nil?

    @seats[@empty_seat] = 'occupied'
  end

  def occupied_seats
    @seats.values.count { |value| value == 'occupied' }
  end

  def free_seats
    @seats.values.count(&:nil?)
  end

  private

  def create_seats(seats_count)
    seats_count.times { |number| @seats[number] = nil }
  end
end
