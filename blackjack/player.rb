class Player
  attr_reader :name, :hand, :account

  def initialize(name)
    @name = name
    @hand = Hand.new
    @account = Account.new(100)
  end
end
