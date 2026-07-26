require_relative 'piece'
class King < Piece
  attr_accessor :symbol

  def initialize(color)
    super
    @symbol = color == :white ? '♔' : '♚'
  end

  def check_piece_move?(start, des, _des_color)
    diff_row = (start[1].to_i - des[1].to_i).abs
    diff_col = (start[0].ord - des[0].ord).abs

    diff_row <= 1 && diff_col <= 1
  end
end
