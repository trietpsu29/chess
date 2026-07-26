require_relative 'piece'
class Rook < Piece
  attr_accessor :symbol

  def initialize(color)
    super
    @symbol = color == :white ? '♖' : '♜'
  end

  def check_piece_move?(start, des, _des_color)
    start[0] == des[0] || start[1] == des[1]
  end
end
