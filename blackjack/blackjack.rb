require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'hand.rb'

deck1 = Deck.new

hand1 = Hand.new

3.times { hand1.take_card_from_deck(deck1) }

puts hand1.show
puts hand1.value
