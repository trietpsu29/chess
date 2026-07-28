require_relative 'board'
require_relative 'menu'
require 'json'

class Game
  attr_accessor :board, :turn, :ai

  def initialize(ai = nil)
    @board = Board.new
    @turn = :white
    @ai = ai
  end

  def play_game
    @board.display
    loop do
      input = @turn == @ai ? ai_turn : make_turn
      return unless input

      start, des = input
      promo_turn(start, des)

      checked = check_turn?
      @turn = @turn == :white ? :black : :white
      next unless checked

      @turn = :white
      @board = Board.new
      return
    end
  end

  def make_turn
    loop do
      turn_menu
      input = gets.chomp

      case input
      when 'save'
        save
        puts 'Game saved!'
        next
      when 'castle'
        castling

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

        if @board.check_valid_move?(@turn, start, des)
          @board.move_piece(start, des)
          @board.display
          return [start, des]
        end

        puts 'Invalid move!'
      end
    end
  end

  def promo_turn(start, des)
    return unless @board.check_promo?(start, des, @turn)

    menu.promotion_menu if @turn != @ai
    choice = @turn == @ai ? %w[Q R B N].sample : gets.chomp
    @board.promo_pawn(des, choice)
    puts 'Pawn promoted!'
    @board.display
  end

  def check_turn?
    king_pos = @turn == :white ? @board.black_king_pos : @board.white_king_pos
    check = check?(king_pos)
    checkmate = checkmate?(king_pos)
    declare_check(check, checkmate)
    checkmate
  end

  def castling_menu
    puts <<~MENU

      ╔══════════════════════════════╗
            ♟ CASTLING ♟
      ╚══════════════════════════════╝

      Choose castling side:

        1. Kingside (O-O)
        2. Queenside (O-O-O)
        0. Cancel

    MENU
  end

  def castling
    castling_menu if @turn != @ai
    choice = @turn == @ai ? rand(0..2) : gets.chomp

    case choice
    when '1'
      if @board.check_kingside_castling?(@turn)
        @board.kingside_castling(@turn)
        puts 'Kingside castling performed!'
        @board.display
        true
      else
        puts 'Cannot perform kingside castling!' if @turn != @ai
        false
      end

    when '2'
      if @board.check_queenside_castling?(@turn)
        @board.queenside_castling(@turn)
        puts 'Queenside castling performed!'
        @board.display
        true
      else
        puts 'Cannot perform queenside castling!' if @turn != @ai
        false
      end

    when '0'
      puts 'Cancel castling.' if @turn != @ai
      false

    else
      puts 'Invalid choice!'
      false
    end
  end

  def check?(king_pos)
    @board.grid.each do |pos, piece|
      return true if !piece.nil? && piece.color == @turn && @board.check_valid_move?(@turn, pos, king_pos)
    end
    false
  end

  def checkmate?(king_pos)
    return false unless check?(king_pos)

    king_col = king_pos[0].ord
    king_row = king_pos[1].to_i
    king_moves = ["#{king_col.chr}#{king_row + 1}", "#{king_col.chr}#{king_row - 1}", "#{(king_col + 1).chr}#{king_row}",
                  "#{(king_col - 1).chr}#{king_row}", "#{(king_col + 1).chr}#{king_row + 1}", "#{(king_col + 1).chr}#{king_row - 1}", "#{(king_col - 1).chr}#{king_row + 1}", "#{(king_col - 1).chr}#{king_row - 1}"]
    king_moves.each do |pos|
      next unless @board.check_valid_move?(@board.grid[king_pos].color, king_pos, pos)

      pos_piece = @board.grid[pos]
      @board.move_piece(king_pos, pos)
      check_king = check?(pos)
      @board.move_piece(pos, king_pos)
      @board.grid[pos] = pos_piece

      return false unless check_king
    end
    true
  end

  def save
    File.write('save.json', JSON.dump({ turn: @turn,
                                        ai: @ai,
                                        board: @board.serialize }))
  end

  def load(string)
    data = JSON.load(string)
    @turn = data['turn'].to_sym
    @ai = data['ai']
    @ai = @ai.to_sym unless @ai.nil?
    @board.deserialize(data['board'])
  end

  def turn_menu(ai = nil)
    puts <<~MENU
      ╔══════════════════════════════╗
           ♟ CHESS - #{@turn.capitalize} TURN ♟
      ╚══════════════════════════════╝
    MENU

    return if ai

    puts <<~MENU

      Enter your move:
        Example: e2 e4

      Commands:
        save - Save current game
        castle - Perform castling
        menu - Return to main menu (game will not be saved)
        exit - Exit game (game will not be saved)

      >
    MENU
  end

  def declare_check(check, checkmate)
    puts 'Check!' if check
    puts "Checkmate! #{@turn.capitalize} wins" if checkmate
  end

  def ai_turn
    turn_menu('ai')
    ai_pieces = find_ai_pieces
    des_move = @board.grid.keys - ai_pieces
    visited = []
    loop do
      start = ai_pieces.sample
      des = des_move.sample
      next if visited.include?([start, des])

      if @board.check_valid_move?(@ai, start, des)
        @board.move_piece(start, des)
        puts "#{start} #{des}"
        @board.display
        return [start, des]
      end
      visited << [start, des]
    end
  end

  def find_ai_pieces
    @board.grid.filter_map do |pos, piece|
      pos if piece&.color == @ai
    end
  end
end
