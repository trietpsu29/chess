require_relative '../lib/bishop'

describe Bishop do
  subject(:bishop) { described_class.new(:white) }

  describe '#check_piece_move?' do
    it 'returns true when moving diagonally up-right' do
      expect(bishop.check_piece_move?('c3', 'f6', nil)).to be true
    end

    it 'returns true when moving diagonally down-right' do
      expect(bishop.check_piece_move?('c6', 'f3', nil)).to be true
    end

    it 'returns true when moving diagonally up-left' do
      expect(bishop.check_piece_move?('f3', 'c6', nil)).to be true
    end

    it 'returns true when moving diagonally down-left' do
      expect(bishop.check_piece_move?('f6', 'c3', nil)).to be true
    end

    it 'returns false when not moving diagonally' do
      expect(bishop.check_piece_move?('c3', 'c6', nil)).to be false
    end
  end
end
