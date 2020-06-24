class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  def initialize(number)
    super
    @type = :passenger
  end
end
