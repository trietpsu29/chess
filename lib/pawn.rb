require_relative 'piece'
class Pawn < Piece
  attr_accessor :symbol

  def initialize(color)
    super
    @symbol = color == :white ? '♙' : '♟'
  end

  def check_valid_move?(start, des, des_color)
    factor_dig = !(start[0] == des[0])
    return false if factor_dig && !check_dig_move?(start, des, des_color)

    start_row = start[1].to_i
    des_row = des[1].to_i
    diff = abs(start_row - des_row)
    return false if factor_dig && diff != 1
    return false if diff > 2
    return false if diff > 1 && start_row != 2 && start_row != 7

    return false if @color == :white && start_row > des_row
    return false if @color == :black && start_row < des_row

    true
  end

  def check_dig_move?(start, des, des_color)
    return false if des_color.nil?

    start_col = start[0].ord
    des_col = des[0].ord
    diff = abs(start_col - des_col)
    false if diff != 1
  end
end
