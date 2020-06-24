class CargoWagon < Wagon
  attr_reader :free_volume

  def initialize(volume)
    @type = :cargo
    @total_volume = volume
    @free_volume = volume
  end

  def take_volume(volume)
    raise "Превышен свободный объем: #{@free_volume}" if (@free_volume - volume).negative?

    @free_volume -= volume
  end

  def occupied_volume
    @total_volume - @free_volume
  end
end
