require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'hand.rb'
require_relative 'account.rb'
require_relative 'player.rb'
require_relative 'dealer.rb'

class BlackJack
  MENU_METHODS = { 1 => :pass, 2 => :add_card, 3 => :open }.freeze

  def initialize
    player_setup
    @dealer = Dealer.new('Дилер')
    @game_account = Account.new
    @deck = Deck.new
  end

  def start
    deal_initial_cards
    make_bets
    player_turn
  end

  private

  def player_setup
    puts 'Введите ваше имя:'
    player_name = 'Alex'
    @player = Player.new(player_name)
  end

  def deal_initial_cards
    2.times { @player.hand.take_card_from_deck(@deck) }
    2.times { @dealer.hand.take_card_from_deck(@deck) }
  end

  def make_bets
    @player.account.transfer_to(@game_account, 10)
    @dealer.account.transfer_to(@game_account, 10)
  end

  def hud
    puts "
    В банке: #{@game_account.amount}$
    #{@player.name}: #{@player.account.amount}$
    #{@dealer.name}: #{@dealer.account.amount}$
    -------------
    Карты #{@player.name}: #{show_hand(@player)}
    Сумма очков: #{show_hand_value(@player)}
    -------------
    Карты #{@dealer.name}: #{show_hand(@dealer)}
    Сумма очков: #{show_hand_value(@dealer)}
    "
  end

  def show_hand(player)
    cards = player.hand.cards_with_suit
    cards.each_with_object([]) do |card, hand|
      card = '*' if player.name == 'Дилер' && @open.nil?
      hand << card
    end
  end

  def show_hand_value(player)
    return if player.name == 'Дилер' && @open.nil?

    player.hand.value
  end

  def player_turn
    hud
    menu
    choice = gets.chomp.to_i
    send(MENU_METHODS[choice])
  end

  def menu
    puts "Ваш ход:
    1. Пропустить
    2. Добавить карту
    3. Открыть карты"
  end
end
