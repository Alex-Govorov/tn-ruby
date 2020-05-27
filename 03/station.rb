class Station
  attr_reader :trains_list

  def initialize(name)
    @name = name
    @trains_list = []
  end

  def get_train(train)
    @trains_list << train
  end

  def release_train(train)
    @trains_list.delete(train)
  end

  def trains_list_by_type(type)
    trains_by_type = []
    freight_count = 0
    coach_count = 0
    @trains_list.each do |train|
      trains_by_type << train if train.type == type
      freight_count += 1 if train.type == 'грузовой'
      coach_count += 1 if train.type == 'пассажирский'
    end
    { trains_by_type: trains_by_type, freight_count: freight_count, coach_count: coach_count }
  end
end
