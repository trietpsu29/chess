require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  before do
    board.clear
  end

  describe '#check_block_move?' do
    it 'returns true when a vertical path is blocked' do
      board.grid['a1'] = Rook.new(:white)
      board.grid['a4'] = Pawn.new(:white)

      expect(board.check_block_move?('a1', 'a8')).to be true
    end

    it 'returns true when a horizontal path is blocked' do
      board.grid['a1'] = Rook.new(:white)
      board.grid['d1'] = Pawn.new(:white)

      expect(board.check_block_move?('a1', 'h1')).to be true
    end

    it 'returns true when a diagonal path is blocked' do
      board.grid['a1'] = Bishop.new(:white)
      board.grid['c3'] = Pawn.new(:white)

      expect(board.check_block_move?('a1', 'h8')).to be true
    end

    it 'returns false when the path is clear' do
      board.grid['a1'] = Rook.new(:white)

      expect(board.check_block_move?('a1', 'a8')).to be false
    end

    it 'does not count the destination square as blocked' do
      board.grid['a1'] = Rook.new(:white)
      board.grid['a8'] = Pawn.new(:black)

      expect(board.check_block_move?('a1', 'a8')).to be false
    end
  end

  describe '#check_valid_move?' do
    let(:piece) { instance_double(Rook) }

    it 'returns false when the start square is empty' do
      expect(board.check_valid_move?('a1', 'a2')).to be false
    end

    it 'returns false when start equals destination' do
      board.grid['a1'] = piece

      expect(board.check_valid_move?('a1', 'a1')).to be false
    end

    it 'returns false when destination contains a friendly piece' do
      allow(piece).to receive(:color).and_return(:white)

      board.grid['a1'] = piece
      board.grid['a2'] = Pawn.new(:white)

      expect(board.check_valid_move?('a1', 'a2')).to be false
    end

    it 'calls check_piece_move?' do
      allow(piece).to receive(:color).and_return(:white)
      allow(piece).to receive(:check_piece_move?).and_return(true)

      board.grid['a1'] = piece

      expect(piece).to receive(:check_piece_move?)

      board.check_valid_move?('a1', 'a2')
    end

    it 'returns false when the path is blocked' do
      allow(piece).to receive(:color).and_return(:white)
      allow(piece).to receive(:check_piece_move?).and_return(true)

      board.grid['a1'] = piece

      allow(board).to receive(:check_block_move?).and_return(true)

      expect(board.check_valid_move?('a1', 'a8')).to be false
    end

    it 'does not check blocking pieces for a knight' do
      knight = Knight.new(:white)

      allow(knight).to receive(:check_piece_move?).and_return(true)

      board.grid['b1'] = knight

      expect(board).not_to receive(:check_block_move?)

      board.check_valid_move?('b1', 'c3')
    end

    it 'returns true for a valid move' do
      allow(piece).to receive(:color).and_return(:white)
      allow(piece).to receive(:check_piece_move?).and_return(true)

      board.grid['a1'] = piece

      allow(board).to receive(:check_block_move?).and_return(false)

      expect(board.check_valid_move?('a1', 'a8')).to be true
    end
  end
end
