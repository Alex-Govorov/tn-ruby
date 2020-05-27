class Train
  attr_reader :car_count
  attr_reader :type
  attr_accessor :current_station

  def initialize(number, type, car_count)
    @number = number
    @type = type
    @car_count = car_count
    @speed = 0
  end

  def speed_up
    @speed += 1
  end

  def current_speed
    @speed
  end

  def stop
    @speed = 0
  end

  def car_add
    @car_count += 1 if @speed.zero?
  end

  def car_remove
    @car_count -= 1 if @speed.zero? && @car_count != 0
  end

  def get_route(route)
    @route = route
    @current_station = route.stations_list.first
  end

  def to_next_station
    @current_station = next_station unless next_station.nil?
  end

  def to_prev_station
    @current_station = prev_station unless prev_station.nil?
  end

  def next_station
    unless @current_station == @route.stations_list.last
      next_station = @route.stations_list[@route.stations_list.find_index(@current_station) + 1]
    end
    next_station
  end

  def prev_station
    unless @current_station == @route.stations_list.first
      prev_station = @route.stations_list[@route.stations_list.find_index(@current_station) - 1]
    end
    prev_station
  end
end
