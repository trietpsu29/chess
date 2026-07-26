require_relative '../lib/king'

describe King do
  subject(:king) { described_class.new(:white) }

  describe '#check_piece_move?' do
    it 'returns true when moving up' do
      expect(king.check_piece_move?('d4', 'd5', nil)).to be true
    end

    it 'returns true when moving down' do
      expect(king.check_piece_move?('d4', 'd3', nil)).to be true
    end

    it 'returns true when moving left' do
      expect(king.check_piece_move?('d4', 'c4', nil)).to be true
    end

    it 'returns true when moving right' do
      expect(king.check_piece_move?('d4', 'e4', nil)).to be true
    end

    it 'returns true when moving diagonally up-left' do
      expect(king.check_piece_move?('d4', 'c5', nil)).to be true
    end

    it 'returns true when moving diagonally up-right' do
      expect(king.check_piece_move?('d4', 'e5', nil)).to be true
    end

    it 'returns true when moving diagonally down-left' do
      expect(king.check_piece_move?('d4', 'c3', nil)).to be true
    end

    it 'returns true when moving diagonally down-right' do
      expect(king.check_piece_move?('d4', 'e3', nil)).to be true
    end

    it 'returns false when moving more than one square' do
      expect(king.check_piece_move?('d4', 'd6', nil)).to be false
    end
  end
end
