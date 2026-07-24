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

  def clear
    @grid = default_board
  end

  private

  def default_board
    board = {}
    ('a'..'h').each do |col|
      (1..8).each do |row|
        board[:"#{col}#{row}"] = nil
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
