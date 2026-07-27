require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  before do
    game.board.clear
  end

  describe '#check?' do
    it 'returns true when a piece can attack king position' do
      rook = Rook.new(:black)

      game.board.grid['a8'] = rook

      expect(game.check?(:black, 'a1')).to be true
    end

    it 'returns false when no piece can attack king position' do
      rook = Rook.new(:black)

      game.board.grid['a8'] = rook

      expect(game.check?(:black, 'h1')).to be false
    end

    it 'does not count pieces from another color' do
      rook = Rook.new(:white)

      game.board.grid['a8'] = rook

      expect(game.check?(:black, 'a1')).to be false
    end
  end

  describe '#checkmate?' do
    it 'returns false when king has an available move' do
      king = King.new(:white)
      rook = Rook.new(:black)

      game.board.grid['e1'] = king
      game.board.grid['e8'] = rook

      expect(game.checkmate?(:black, 'e1')).to be false
    end

    it 'returns true when king has no available move' do
      king = King.new(:white)

      rook1 = Rook.new(:black)
      rook2 = Rook.new(:black)
      rook3 = Rook.new(:black)

      game.board.grid['e1'] = king
      game.board.grid['e2'] = rook1
      game.board.grid['d2'] = rook2
      game.board.grid['f2'] = rook3

      expect(game.checkmate?(:black, 'e1')).to be true
    end
  end
end
