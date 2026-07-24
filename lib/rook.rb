require_relative 'piece'
class Rook < Piece
  attr_accessor :symbol

  def initialize(color)
    super
    @symbol = color == :white ? '♖' : '♜'
  end
end
