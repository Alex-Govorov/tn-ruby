class Station
  attr_reader :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def get_train(train)
    @trains << train
  end

  def release_train(train)
    @trains.delete(train)
  end

  private

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
end
