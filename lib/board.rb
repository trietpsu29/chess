require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'
require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    @grid = default_board
    setup_piece
  end

  def check_block_move?(start, des)
    start_color = @grid[start].color
    start_col = start[0].ord
    des_col = des[0].ord
    start_row = start[1].to_i
    des_row = des[1].to_i

    factor_col = start_color == :white ? 1 : -1
    factor_row = start_col < des_col ? 1 : -1
    factor_dig = start_col != des_col && start_row != des_row ? true : false
    curr_col = start_col
    curr_row = start_row
    loop do
      curr_row += factor_col if start_col == des_col || factor_dig
      curr_col += factor_row if start_row == des_row || factor_dig
      curr = @grid["#{curr_col.chr}#{curr_row.to_i}"]
      break if curr == @grid[des]
      return true unless curr.nil?
    end
    false
  end

  def check_valid_move?(start, des)
    return false if @grid[start].nil?
    return false if start == des
    return false unless @grid[start].check_piece_move?
    return false if @grid[start].color == @grid[des].color
    return false if !@grid[start].is_a?(Knight) && check_block_move?

    true
  end

  def move_piece(start, des)
    @grid[des] = @grid[start]
    @grid[start] = nil
  end

  def clear
    @grid = default_board
  end

  def display
    8.downto(1) do |row|
      print "#{row} "

      ('a'..'h').each do |col|
        piece = @grid["#{col}#{row}"]

        if piece.nil?
          print '. '
        else
          print "#{piece.symbol} "
        end
      end

      puts
    end

    print '  '
    ('a'..'h').each { |col| print "#{col} " }
    puts
  end

  private

  def default_board
    board = {}
    ('a'..'h').each do |col|
      (1..8).each do |row|
        board["#{col}#{row}"] = nil
      end
    end
    board
  end

  def setup_piece
    @grid[:a8] = Rook.new(:black)
    @grid[:b8] = Knight.new(:black)
    @grid[:c8] = Bishop.new(:black)
    @grid[:d8] = Queen.new(:black)
    @grid[:e8] = King.new(:black)
    @grid[:f8] = Bishop.new(:black)
    @grid[:g8] = Knight.new(:black)
    @grid[:h8] = Rook.new(:black)

    @grid[:a1] = Rook.new(:white)
    @grid[:b1] = Knight.new(:white)
    @grid[:c1] = Bishop.new(:white)
    @grid[:d1] = Queen.new(:white)
    @grid[:e1] = King.new(:white)
    @grid[:f1] = Bishop.new(:white)
    @grid[:g1] = Knight.new(:white)
    @grid[:h1] = Rook.new(:white)

    ('a'..'h').each do |file|
      @grid[:"#{file}2"] = Pawn.new(:white)
      @grid[:"#{file}7"] = Pawn.new(:black)
    end
  end
end
