require_relative '../lib/rook'

describe Rook do
  subject(:rook) { described_class.new(:white) }

  describe '#check_piece_move?' do
    it 'returns true when moving on the same row' do
      expect(rook.check_piece_move?('a1', 'h1', nil)).to be true
    end

    it 'returns true when moving on the same column' do
      expect(rook.check_piece_move?('a1', 'a8', nil)).to be true
    end

    it 'returns false when not moving on the same row or column' do
      expect(rook.check_piece_move?('a1', 'b2', nil)).to be false
    end
  end
end
