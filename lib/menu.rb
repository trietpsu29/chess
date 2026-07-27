require_relative 'game'

class Menu
  def initialize
    @running = true
  end

  def start
    while @running
      display_menu
      choice = gets.chomp

      case choice
      when '1'
        new_game_menu
      when '2'
        load_game
      when '3'
        quit
      else
        puts 'Invalid option!'
      end
    end
  end

  def promotion_menu
    puts <<~PROMO
      Promote pawn to:
      Q: Queen
      R: Rook
      B: Bishop
      N: Knight
    PROMO
  end

  def declare_check(check, checkmate, player)
    puts 'Check!' if check
    puts "Checkmate! #{player.capitalize} wins" if checkmate
  end

  private

  def display_menu
    puts <<~CHESS

       ██████╗██╗  ██╗███████╗███████╗███████╗
      ██╔════╝██║  ██║██╔════╝██╔════╝██╔════╝
      ██║     ███████║█████╗  ███████╗███████╗
      ██║     ██╔══██║██╔══╝  ╚════██║╚════██║
      ╚██████╗██║  ██║███████╗███████║███████║
       ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

                ♔  C H E S S  ♚

      1. New Game
      2. Load Game
      3. Quit

    CHESS

    print 'Choose an option: '
  end

  def new_game_menu
    loop do
      puts <<~MENU

        New Game

        1. Play against another player
        2. Play against computer
        3. Back

      MENU

      print 'Choose an option: '
      choice = gets.chomp

      case choice
      when '1'
        start_player_game
      when '2'
        start_ai_game
      when '3'
        break
      else
        puts 'Invalid option!'
      end
    end
  end

  def start_player_game
    puts 'Player vs Player'
    game = Game.new
    game.play
  end

  def start_ai_game
    # TODO: create game with computer
    puts 'Player vs Computer'
  end

  def load_game
    # TODO: load saved game
    puts 'Load game'
  end

  def quit
    puts 'Thanks for playing Chess!'
    @running = false
  end
end
