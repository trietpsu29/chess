require_relative 'piece'
class Bishop < Piece
  attr_accessor :symbol

  def initialize(color)
    super
    @symbol = color == :white ? '♗' : '♝'
  end
end
