require_relative 'instance_counter.rb'
require_relative 'brand.rb'
require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'station.rb'
require_relative 'route.rb'

class RailRoad
  MENU_METHODS = {
    1 => :create_station, 2 => :create_train, 3 => :manage_routes, 4 => :train_get_route,
    5 => :train_add_wagon, 6 => :train_remove_wagon, 7 => :move_train, 8 => :trains_on_stations,
    9 => :fill_wagon, 0 => :exit
  }.freeze
  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def start
    menu
    choice = gets.chomp.to_i
    send(MENU_METHODS[choice])
  end

  private

  def exit
    puts 'Хорошего дня!'
  end

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
    8. Посмотреть список станций с поездами и вагонами на них
    9. Занять место или объём в вагоне
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
    begin
      create_train_menu
      choice = gets.chomp.to_i

      puts 'Введите номер поезда:'
      number = gets.chomp

      case choice
      when 1
        @trains << PassengerTrain.new(number)

      when 2
        @trains << CargoTrain.new(number)
      end
    rescue RuntimeError => e
      puts e.message
      retry
    end

    puts "Поезд #{number} создан"
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

  def choose_wagon(train)
    puts 'Выберите вагон:'
    train.wagons.each_with_index { |_wagon, index| puts index }
    train.wagons[gets.chomp.to_i]
  end

  def train_add_wagon
    train = choose_train
    wagons_stats_message(train)
    wagon_stats = gets.chomp.to_i
    train.add_wagon(PassengerWagon.new(wagon_stats)) if train.type == :passenger
    train.add_wagon(CargoWagon.new(wagon_stats)) if train.type == :cargo

    puts 'Вагон прицеплен'
    start
  end

  def wagons_stats_message(train)
    puts 'Введите кол-во мест' if train.type == :passenger
    puts 'Введите объём' if train.type == :cargo
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
      station.trains_info(&train_info_block)
    end
    start
  end

  def wagon_info_block
    ->(wagon, index) { puts "  :Вагон№:#{index}, тип:#{wagon.type}, #{wagon_status(wagon)}" }
    # Изначально в train_info_block была такая-же, форма записи.
    # Но т.к . в отличии от wagon_info_block там используется блок из 2х строк,
    # на него ругался rubocop с ошибкой "use the lambda method for multiline lambdas"
    # и я переписал train_info_block, чтобы метод соответствовал соглашению по стилю:
    # https://github.com/rubocop-hq/ruby-style-guide#lambda-multi-line
  end

  def wagon_status(wagon)
    if wagon.type == :passenger
      "cвободно:#{wagon.free_seats}, занято:#{wagon.occupied_seats}"
    elsif wagon.type == :cargo
      "cвободно:#{wagon.free_volume}, занято:#{wagon.occupied_volume}"
    end
  end

  def train_info_block
    lambda do |train|
      puts " :Поезд№:#{train.number}, тип:#{train.type}, вагонов:#{train.wagons.count}"
      train.wagons_info(&wagon_info_block)
    end
  end

  def fill_wagon
    train = choose_train
    wagon = choose_wagon(train)

    if wagon.type == :passenger
      wagon.take_seat
      puts "Место занято, осталось мест:#{wagon.free_seats}"
    elsif wagon.type == :cargo
      puts 'Введите занимаемый объём:'
      volume = gets.chomp.to_i
      wagon.take_volume(volume)
      puts "Успешно занято, осталось места:#{wagon.free_volume}"
    end

    start
  end
end
