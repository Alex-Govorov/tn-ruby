class Train
  include InstanceCounter
  include Brand
  attr_reader :type
  attr_reader :number
  attr_reader :wagons
  attr_reader :route
  NUMBER_FORMAT = /^[a-zа-я0-9]{3}-*[a-zа-я0-9]{2}$/i.freeze

  @all_trains = []

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    validate!(number)
    register_instance
    Train.all_trains << self
  end

  def self.find(number)
    find = @all_trains.select { |train| train.number == number }
    find.empty? ? nil : find
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

  def valid?
    validate!(@number)
    true
  rescue RuntimeError
    false
  end

  def wagons_info(&block)
    raise 'No block given' unless block_given?

    @wagons.each_with_index { |wagon, number| block.call(wagon, number) }
  end

  protected

  class << self
    attr_accessor :all_trains
  end

  attr_accessor :current_station

  def validate!(number)
    raise 'Не правильный формат номера' if number !~ NUMBER_FORMAT
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
