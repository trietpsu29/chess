require_relative '../lib/queen'

describe Queen do
  subject(:queen) { described_class.new(:white) }

  describe '#check_piece_move?' do
    it 'returns true when moving horizontally' do
      expect(queen.check_piece_move?('d4', 'h4', nil)).to be true
    end

    it 'returns true when moving vertically' do
      expect(queen.check_piece_move?('d4', 'd8', nil)).to be true
    end

    it 'returns true when moving diagonally up-right' do
      expect(queen.check_piece_move?('d4', 'g7', nil)).to be true
    end

    it 'returns true when moving diagonally up-left' do
      expect(queen.check_piece_move?('d4', 'a7', nil)).to be true
    end

    it 'returns true when moving diagonally down-right' do
      expect(queen.check_piece_move?('d4', 'g1', nil)).to be true
    end

    it 'returns true when moving diagonally down-left' do
      expect(queen.check_piece_move?('d4', 'a1', nil)).to be true
    end

    it 'returns false when moving in an invalid direction' do
      expect(queen.check_piece_move?('d4', 'f5', nil)).to be false
    end
  end
end
