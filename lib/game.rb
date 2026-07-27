require_relative 'board'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def check?(player, king_pos)
    @board.grid.each do |pos, piece|
      return true if !piece.nil? && piece.color == player && @board.check_valid_move?(player, pos, king_pos)
    end
    false
  end

  def checkmate?(player, king_pos)
    king_col = king_pos[0].ord
    king_row = king_pos[1].to_i
    king_moves = ["#{king_col.chr}#{king_row + 1}", "#{king_col.chr}#{king_row - 1}", "#{(king_col + 1).chr}#{king_row}",
                  "#{(king_col - 1).chr}#{king_row}", "#{(king_col + 1).chr}#{king_row + 1}", "#{(king_col + 1).chr}#{king_row - 1}", "#{(king_col - 1).chr}#{king_row + 1}", "#{(king_col - 1).chr}#{king_row - 1}"]
    king_moves.each do |pos|
      next unless @board.check_valid_move?(@board.grid[king_pos].color, king_pos, pos)

      pos_piece = @board.grid[pos]
      @board.move_piece(king_pos, pos)
      check_king = check?(player, pos)
      @board.move_piece(pos, king_pos)
      @board.grid[pos] = pos_piece

      return false unless check_king
    end
    true
  end
end
