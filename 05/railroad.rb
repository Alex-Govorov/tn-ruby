require_relative 'instance_counter.rb.rb'
require_relative 'train.rb'
require_relative 'brand.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'station.rb'
require_relative 'route.rb'

class RailRoad
  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def start
    menu

    choice = gets.chomp.to_i

    case choice
    when 1
      create_station
    when 2
      create_train
    when 3
      manage_routes
    when 4
      train_get_route
    when 5
      train_add_wagon
    when 6
      train_remove_wagon
    when 7
      move_train
    when 8
      trains_on_stations
    when 0
      puts 'Хорошего дня!'
    end
  end

  private

  def menu
    puts "Вас приветсвует система управления железной дорогой!\n
    Выберите действие:
    1. Создать станцию
    2. Создать поезд
    3. Управлять маршрутами
    4. Назначить маршрут поезду
    5. Прицепить вагон к поезду
    6. Отцепить вагон от поезда
    7. Перемещать поезд по маршруту
    8. Посмотреть список станций и поездов на них
    0. Выход"
  end

  def create_station
    puts 'Введите название станции:'
    name = gets.chomp
    @stations << Station.new(name)

    puts "Станция #{name} создана"
    start
  end

  def create_train
    create_train_menu
    choice = gets.chomp.to_i

    puts 'Введите номер поезда:'
    name = gets.chomp

    case choice
    when 1
      @trains << PassengerTrain.new(name)
    when 2
      @trains << CargoTrain.new(name)
    end

    puts "Поезд #{name} создан"
    start
  end

  def create_train_menu
    puts "Выберите тип поезда:
    1. Пассажирский
    2. Грузовой"
  end

  def manage_routes
    manage_routes_menu
    choice = gets.chomp.to_i
    case choice
    when 1
      create_route
    when 2
      route = choose_route
      choose_route_action(route)
    end

    start
  end

  def choose_route_action(route)
    puts "Выберите:
    1. Добавить станцию
    2. Удалить станцию"
    choice = gets.chomp.to_i
    case choice
    when 1
      puts 'Выберите какую станцию добавить:'
      station = choose_station
      route.add_station(station)
    when 2
      puts 'Выберите какую станцию удалить:'
      station = choose_route_station(route)
      route.remove_station(station)
    end
  end

  def manage_routes_menu
    puts "Выберите:
    1. Создать новый маршрут
    2. Добавить/удалить станцию у существующего"
  end

  def choose_route
    puts 'Выберите маршрут:'
    @routes.each_with_index do |route, index|
      puts "#{index} #{route.stations.first.name}-#{route.stations.last.name}"
    end
    @routes[gets.chomp.to_i]
  end

  def create_route
    puts 'Выберите начальную станцию:'
    first_station = choose_station

    puts 'Выберите конечную станцию:'
    last_station = choose_station

    @routes << Route.new(first_station, last_station)
    puts "Маршрут #{first_station.name} - #{last_station.name} создан"
  end

  def choose_station
    @stations.each_with_index { |station, index| puts "#{index} #{station.name}" }
    @stations[gets.chomp.to_i]
  end

  def choose_route_station(route)
    route.stations.each_with_index { |station, index| puts "#{index} #{station.name}" }
    route.stations[gets.chomp.to_i]
  end

  def train_get_route
    train = choose_train
    route = choose_route
    train.get_route(route)
    start
  end

  def choose_train
    puts 'Выберите поезд:'
    @trains.each_with_index { |train, index| puts "#{index} #{train.number}" }
    @trains[gets.chomp.to_i]
  end

  def train_add_wagon
    train = choose_train
    train.add_wagon(PassengerWagon.new) if train.type == :passenger
    train.add_wagon(CargoWagon.new) if train.type == :cargo

    puts 'Вагон прицеплен'
    start
  end

  def train_remove_wagon
    train = choose_train
    if train.wagons.nil?
      puts 'У поезда не прицеплены вагоны'
      start
    end

    train.remove_wagon(train.wagons.last)
    puts 'Вагон отцеплен'
    start
  end

  def move_train
    train = choose_train
    if train.route.nil?
      puts 'Поезду не назначен маршрут'
      start
    end
    move_train_action(train)
    start
  end

  def move_train_action(train)
    puts "Выберите:
    1. Едем на следующую станцию
    2. Едем на предыдущую станцию"

    choice = gets.chomp.to_i

    case choice
    when 1
      train.to_next_station
    when 2
      train.to_prev_station
    end
  end

  def trains_on_stations
    @stations.each do |station|
      puts station.name
      station.trains.each do |train|
        puts ": #{train.number}"
      end
    end
    start
  end
end
