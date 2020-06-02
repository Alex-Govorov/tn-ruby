class Train
  attr_reader :type
  attr_reader :number
  attr_reader :wagons
  attr_reader :route

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
  end

  def add_wagon(wagon)
    @wagons << wagon if wagon.type == @type && @speed.zero?
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if @speed.zero? && @wagons.any?
  end

  def get_route(route)
    @route = route
    @current_station = route.stations.first
    @current_station.get_train(self)
  end

  def to_next_station
    return if next_station.nil?

    @current_station.release_train(self)
    @current_station = next_station
    @current_station.get_train(self)
  end

  def to_prev_station
    return if prev_station.nil?

    @current_station.release_train(self)
    @current_station = prev_station
    @current_station.get_train(self)
  end

  protected

  attr_accessor :current_station

  def speed_up
    @speed += 1
  end

  def current_speed
    @speed
  end

  def stop
    @speed = 0
  end

  def next_station
    unless @current_station == @route.stations.last
      next_station = @route.stations[@route.stations.find_index(@current_station) + 1]
    end
    next_station
  end

  def prev_station
    unless @current_station == @route.stations.first
      prev_station = @route.stations[@route.stations.find_index(@current_station) - 1]
    end
    prev_station
  end
end
