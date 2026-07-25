require_relative '../lib/pawn'
describe Pawn do
  describe '#check_dig_move?' do
    subject(:pawn) { described_class.new(:white) }

    it 'returns false when destination is empty' do
      expect(pawn.check_dig_move?('e2', 'f3', nil)).to be false
    end

    it 'returns true when capturing one file diagonally' do
      expect(pawn.check_dig_move?('e2', 'f3', :black)).to be true
    end

    it 'returns false when destination is more than one file away' do
      expect(pawn.check_dig_move?('e2', 'g3', :black)).to be false
    end

    it 'returns false when destination is in the same file' do
      expect(pawn.check_dig_move?('e2', 'e3', :black)).to be false
    end
  end

  describe '#check_valid_move?' do
    context 'when the pawn is white' do
      let(:pawn) { Pawn.new(:white) }

      it 'allows moving forward one square' do
        expect(pawn.check_valid_move?('e2', 'e3', nil)).to be true
      end

      it 'allows moving forward two squares from the starting position' do
        expect(pawn.check_valid_move?('e2', 'e4', nil)).to be true
      end

      it 'does not allow moving forward three squares' do
        expect(pawn.check_valid_move?('e2', 'e5', nil)).to be false
      end

      it 'does not allow moving backward' do
        expect(pawn.check_valid_move?('e3', 'e2', nil)).to be false
      end

      it 'does not allow moving two squares after leaving the starting position' do
        expect(pawn.check_valid_move?('e3', 'e5', nil)).to be false
      end

      it 'allows a diagonal capture' do
        expect(pawn.check_valid_move?('e2', 'f3', :black)).to be true
      end

      it 'does not allow a diagonal move without a piece to capture' do
        expect(pawn.check_valid_move?('e2', 'f3', nil)).to be false
      end

      it 'does not allow moving two files diagonally' do
        expect(pawn.check_valid_move?('e2', 'g3', :black)).to be false
      end

      it 'does not allow capturing an enemy piece by moving straight forward' do
        expect(pawn.check_valid_move?('e2', 'e3', :black)).to be false
      end
    end

    context 'when the pawn is black' do
      let(:pawn) { Pawn.new(:black) }

      it 'allows moving forward one square' do
        expect(pawn.check_valid_move?('e7', 'e6', nil)).to be true
      end

      it 'allows moving forward two squares from the starting position' do
        expect(pawn.check_valid_move?('e7', 'e5', nil)).to be true
      end

      it 'does not allow moving backward' do
        expect(pawn.check_valid_move?('e6', 'e7', nil)).to be false
      end

      it 'allows a diagonal capture' do
        expect(pawn.check_valid_move?('e7', 'd6', :white)).to be true
      end

      it 'does not allow a diagonal move without a capture' do
        expect(pawn.check_valid_move?('e7', 'd6', nil)).to be false
      end

      it 'does not allow moving onto a friendly piece' do
        expect(pawn.check_valid_move?('e2', 'e3', :white)).to be false
      end
    end
  end
end
