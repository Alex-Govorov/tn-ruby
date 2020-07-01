require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'hand.rb'
require_relative 'account.rb'

player_account = Account.new(100)
dealer_account = Account.new(100)

puts player_account.amount
puts dealer_account.amount

player_account.transfer_to(dealer_account, 120)

puts player_account.amount
puts dealer_account.amount
