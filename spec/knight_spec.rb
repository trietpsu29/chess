require_relative '../lib/knight'

describe Knight do
  subject(:knight) { described_class.new(:white) }

  describe '#check_piece_move?' do
    it 'returns true when moving two left and one up' do
      expect(knight.check_piece_move?('d4', 'b5', nil)).to be true
    end

    it 'returns true when moving two right and one up' do
      expect(knight.check_piece_move?('d4', 'f5', nil)).to be true
    end

    it 'returns true when moving one left and two up' do
      expect(knight.check_piece_move?('d4', 'c6', nil)).to be true
    end

    it 'returns true when moving one right and two up' do
      expect(knight.check_piece_move?('d4', 'e6', nil)).to be true
    end

    it 'returns true when moving two left and one down' do
      expect(knight.check_piece_move?('d4', 'b3', nil)).to be true
    end

    it 'returns true when moving two right and one down' do
      expect(knight.check_piece_move?('d4', 'f3', nil)).to be true
    end

    it 'returns true when moving one left and two down' do
      expect(knight.check_piece_move?('d4', 'c2', nil)).to be true
    end

    it 'returns true when moving one right and two down' do
      expect(knight.check_piece_move?('d4', 'e2', nil)).to be true
    end

    it 'returns false for an invalid move' do
      expect(knight.check_piece_move?('d4', 'd5', nil)).to be false
    end
  end
end
