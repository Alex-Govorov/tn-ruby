class Wagon
  include Brand
  attr_reader :type

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  private

  def validate!
    # Валидация
  end
end
