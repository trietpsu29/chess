require_relative 'piece'
class Knight < Piece
  attr_accessor :symbol

  def initialize(color)
    super
    @symbol = color == :white ? '♘' : '♞'
  end

  def check_piece_move?(start, des, _des_color)
    start_row = start[1].to_i
    des_row = des[1].to_i
    start_col = start[0].ord
    des_col = des[0].ord
    valid_pos =
      [
        [start_col - 2, start_row + 1],
        [start_col + 2, start_row + 1],
        [start_col - 1, start_row + 2],
        [start_col + 1, start_row + 2],
        [start_col - 2, start_row - 1],
        [start_col + 2, start_row - 1],
        [start_col - 1, start_row - 2],
        [start_col + 1, start_row - 2]
      ]
    valid_pos.include?([des_col, des_row])
  end
end
