class Station
  include InstanceCounter
  attr_reader :trains
  attr_reader :name

  @all = []

  def initialize(name)
    @name = name
    @trains = []
    register_instance
    self.class.all << self
  end

  def get_train(train)
    @trains << train
  end

  def release_train(train)
    @trains.delete(train)
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def trains_info
    raise 'No block given' unless block_given?

    @trains.each { |train| yield(train) }
  end

  private

  class << self
    attr_accessor :all
  end

  def trains_by_type(type)
    trains_by_type = []
    freight_count = 0
    coach_count = 0
    @trains.each do |train|
      trains_by_type << train if train.type == type
      freight_count += 1 if train.type == :cargo
      coach_count += 1 if train.type == :passenger
    end
    { trains_by_type: trains_by_type, freight_count: freight_count, coach_count: coach_count }
  end

  def validate!
    # Валидация
  end
end
