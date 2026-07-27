require_relative 'board'
require_relative 'menu'
require 'json'

class Game
  attr_accessor :board, :turn

  def initialize
    @board = Board.new
    @turn = :white
  end

  def play_game
    @board.display
    loop do
      input = make_turn(turn)
      return unless input

      start, des = input

      king_pos = turn == :white ? @board.black_king_pos : @board.white_king_pos
      check = check?(turn, king_pos)
      checkmate = checkmate?(turn, king_pos)
      if @board.check_promo?(turn, start, des)
        menu.promotion_menu
        choice = gets.chomp
        @board.promo_pawn(des, choice)
      end
      menu.declare_check(check, checkmate, turn)
      @turn = turn == :white ? :black : :white
      next unless checkmate

      @turn = :white
      @board = Board.new
      return
    end
  end

  def make_turn(player)
    loop do
      turn_menu(player)
      input = gets.chomp

      case input
      when 'save'
        save
        puts 'Game saved!'
        next

      when 'menu'
        puts 'Warning: Current game will be lost.'
        puts 'Return to main menu? (y/n)'

        confirm = gets.chomp

        return nil if confirm == 'y'

      when 'exit'
        puts 'Are you sure you want to exit? (y/n)'

        confirm = gets.chomp

        exit if confirm == 'y'

      else
        start, des = input.split

        if @board.check_valid_move?(player, start, des)
          @board.move_piece(start, des)
          return [start, des]
        end

        puts 'Invalid move!'
      end
    end
  end

  def check?(player, king_pos)
    @board.grid.each do |pos, piece|
      return true if !piece.nil? && piece.color == player && @board.check_valid_move?(player, pos, king_pos)
    end
    false
  end

  def checkmate?(player, king_pos)
    return false unless check?(player, king_pos)

    king_col = king_pos[0].ord
    king_row = king_pos[1].to_i
    king_moves = ["#{king_col.chr}#{king_row + 1}", "#{king_col.chr}#{king_row - 1}", "#{(king_col + 1).chr}#{king_row}",
                  "#{(king_col - 1).chr}#{king_row}", "#{(king_col + 1).chr}#{king_row + 1}", "#{(king_col + 1).chr}#{king_row - 1}", "#{(king_col - 1).chr}#{king_row + 1}", "#{(king_col - 1).chr}#{king_row - 1}"]
    king_moves.each do |pos|
      next unless @board.check_valid_move?(@board.grid[king_pos].color, king_pos, pos)

      pos_piece = @board.grid[pos]
      @board.move_piece(king_pos, pos)
      check_king = check?(player, pos)
      @board.move_piece(pos, king_pos)
      @board.grid[pos] = pos_piece

      return false unless check_king
    end
    true
  end

  def save
    File.write('save.json', JSON.dump({ turn: @turn,
                                        board: @board.serialize }))
  end

  def load(string)
    data = JSON.load(string)
    @turn = data['turn']
    @board.deserialize(data['board'])
  end

  def turn_menu(player)
    puts <<~MENU

      ╔══════════════════════════════╗
           ♟ CHESS - #{player.capitalize} TURN ♟
      ╚══════════════════════════════╝

      Enter your move:
        Example: e2 e4

      Commands:
        save - Save current game
        menu - Return to main menu (game will not be saved)
        exit - Exit game (game will not be saved)

      >
    MENU
  end

  def declare_check(check, checkmate, player)
    puts 'Check!' if check
    puts "Checkmate! #{player.capitalize} wins" if checkmate
  end
end
