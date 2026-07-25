require_relative 'piece'
class Bishop < Piece
  attr_accessor :symbol

  def initialize(color)
    super
    @symbol = color == :white ? '♗' : '♝'
  end

  def check_piece_move(start, des, _des_color)
    start_row = start[1].to_i
    des_row = des[1].to_i
    start_col = start[0].ord
    des_col = des[0].ord
    diff_row = (start_row - des_row).abs
    diff_col = (start_col - des_col).abs
    diff_row == diff_col
  end
end
