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

    it 'returns false when king has no moves but is not in check' do
      king = King.new(:white)

      pawn1 = Pawn.new(:white)
      pawn2 = Pawn.new(:white)
      pawn3 = Pawn.new(:white)

      game.board.grid['e1'] = king
      game.board.grid['d1'] = pawn1
      game.board.grid['d2'] = pawn2
      game.board.grid['e2'] = pawn3

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

  describe '#save' do
    it 'serializes board and writes save data into file' do
      expect(game.board).to receive(:serialize).and_return({})

      expect(File).to receive(:write)
        .with('save.json', anything)

      game.save
    end
  end

  describe '#load' do
    it 'calls deserialize on board' do
      data = {
        'turn' => 'black',
        'board' => {}
      }

      expect(game.board).to receive(:deserialize)
        .with(data['board'])

      game.load(JSON.dump(data))
    end

    it 'updates game data from saved data' do
      data = {
        'turn' => 'black',
        'board' => {}
      }

      allow(game.board).to receive(:deserialize)

      game.load(JSON.dump(data))

      expect(game.turn).to eq('black')
    end

    it 'restores board state from saved data' do
      data = {
        'turn' => 'black',
        'board' => {
          'white_king_pos' => 'e1',
          'black_king_pos' => 'e8',
          'grid' => {
            'a1' => 'white_rook'
          }
        }
      }

      game.load(JSON.dump(data))

      expect(game.board.grid['a1']).to be_a(Rook)
      expect(game.board.white_king_pos).to eq('e1')
      expect(game.board.black_king_pos).to eq('e8')
    end
  end
end
