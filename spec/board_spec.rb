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

  describe '#check_inside_move?' do
    it 'returns true when both positions are inside the board' do
      expect(board.check_inside_move?('a1', 'h8')).to be true
    end

    it 'returns false when start column is outside the board' do
      expect(board.check_inside_move?('i1', 'h8')).to be false
    end

    it 'returns false when start row is outside the board' do
      expect(board.check_inside_move?('a9', 'h8')).to be false
    end

    it 'returns false when destination column is outside the board' do
      expect(board.check_inside_move?('a1', 'i8')).to be false
    end

    it 'returns false when destination row is outside the board' do
      expect(board.check_inside_move?('a1', 'h9')).to be false
    end

    it 'returns false when position length is not two characters' do
      expect(board.check_inside_move?('a', 'h8')).to be false
      expect(board.check_inside_move?('a1', 'h')).to be false
    end
  end

  describe '#check_valid_move?' do
    let(:piece) { instance_double(Rook) }

    it 'returns false when move position is outside the board' do
      expect(board.check_valid_move?(:white, 'a1', 'a9')).to be false
    end

    it 'returns false when piece does not belong to current player' do
      piece = Rook.new(:black)

      board.grid['a1'] = piece

      expect(board.check_valid_move?(:white, 'a1', 'a8')).to be false
    end

    it 'returns false when the start square is empty' do
      expect(board.check_valid_move?(:white, 'a1', 'a2')).to be false
    end

    it 'returns false when start equals destination' do
      board.grid['a1'] = piece

      expect(board.check_valid_move?(:white, 'a1', 'a1')).to be false
    end

    it 'returns false when destination contains a friendly piece' do
      allow(piece).to receive(:color).and_return(:white)

      board.grid['a1'] = piece
      board.grid['a2'] = Pawn.new(:white)

      expect(board.check_valid_move?(:white, 'a1', 'a2')).to be false
    end

    it 'calls check_piece_move?' do
      allow(piece).to receive(:color).and_return(:white)
      allow(piece).to receive(:check_piece_move?).and_return(true)

      board.grid['a1'] = piece

      expect(piece).to receive(:check_piece_move?)

      board.check_valid_move?(:white, 'a1', 'a2')
    end

    it 'returns false when the piece movement is invalid' do
      allow(piece).to receive(:color).and_return(:white)
      allow(piece).to receive(:check_piece_move?).and_return(false)

      board.grid['a1'] = piece

      expect(board.check_valid_move?(:white, 'a1', 'a8')).to be false
    end

    it 'returns false when the path is blocked' do
      allow(piece).to receive(:color).and_return(:white)
      allow(piece).to receive(:check_piece_move?).and_return(true)

      board.grid['a1'] = piece

      allow(board).to receive(:check_block_move?).and_return(true)

      expect(board.check_valid_move?(:white, 'a1', 'a8')).to be false
    end

    it 'does not check blocking pieces for a knight' do
      knight = Knight.new(:white)

      allow(knight).to receive(:check_piece_move?).and_return(true)

      board.grid['b1'] = knight

      expect(board).not_to receive(:check_block_move?)

      board.check_valid_move?(:white, 'b1', 'c3')
    end

    it 'returns true for a valid move' do
      allow(piece).to receive(:color).and_return(:white)
      allow(piece).to receive(:check_piece_move?).and_return(true)

      board.grid['a1'] = piece

      allow(board).to receive(:check_block_move?).and_return(false)

      expect(board.check_valid_move?(:white, 'a1', 'a8')).to be true
    end
  end

  describe '#check_kingside_castling?' do
    it 'returns true when spaces are empty and rook exists' do
      board.grid['h1'] = Rook.new(:white)

      expect(board.check_kingside_castling?(:white)).to be true
    end

    it 'returns false when there is a piece between king and rook' do
      board.grid['f1'] = Pawn.new(:white)
      board.grid['h1'] = Rook.new(:white)

      expect(board.check_kingside_castling?(:white)).to be false
    end

    it 'returns false when rook does not exist' do
      expect(board.check_kingside_castling?(:white)).to be false
    end
  end

  describe '#check_queenside_castling?' do
    it 'returns true when spaces are empty and rook exists' do
      board.grid['a1'] = Rook.new(:white)

      expect(board.check_queenside_castling?(:white)).to be true
    end

    it 'returns false when there is a piece between king and rook' do
      board.grid['c1'] = Pawn.new(:white)
      board.grid['a1'] = Rook.new(:white)

      expect(board.check_queenside_castling?(:white)).to be false
    end

    it 'returns false when rook does not exist' do
      expect(board.check_queenside_castling?(:white)).to be false
    end
  end

  describe '#kingside_castling' do
    it 'moves king and rook to correct positions' do
      king = King.new(:white)
      rook = Rook.new(:white)

      board.grid['e1'] = king
      board.grid['h1'] = rook

      board.kingside_castling(:white)

      expect(board.grid['g1']).to eq king
      expect(board.grid['f1']).to eq rook
      expect(board.grid['e1']).to be_nil
      expect(board.grid['h1']).to be_nil
    end
  end

  describe '#queenside_castling' do
    it 'moves king and rook to correct positions' do
      king = King.new(:white)
      rook = Rook.new(:white)

      board.grid['e1'] = king
      board.grid['a1'] = rook

      board.queenside_castling(:white)

      expect(board.grid['c1']).to eq king
      expect(board.grid['d1']).to eq rook
      expect(board.grid['e1']).to be_nil
      expect(board.grid['a1']).to be_nil
    end
  end

  describe '#check_promo?' do
    it 'returns false when the piece is not a pawn' do
      board.grid['a7'] = Queen.new(:white)

      expect(board.check_promo?(:white, 'a7', 'a8')).to be false
    end

    it 'returns true when black pawn reaches rank 1' do
      board.grid['a2'] = Pawn.new(:black)

      expect(board.check_promo?(:black, 'a2', 'a1')).to be true
    end

    it 'returns true when white pawn reaches rank 8' do
      board.grid['a7'] = Pawn.new(:white)

      expect(board.check_promo?(:white, 'a7', 'a8')).to be true
    end

    it 'returns false when pawn has not reached promotion rank' do
      board.grid['a6'] = Pawn.new(:white)

      expect(board.check_promo?(:white, 'a6', 'a7')).to be false
    end
  end

  describe '#promo_pawn' do
    before do
      board.grid['a8'] = Pawn.new(:white)
    end

    it 'promotes pawn to queen' do
      board.promo_pawn('a8', 'Q')

      expect(board.grid['a8']).to be_a(Queen)
      expect(board.grid['a8'].color).to eq(:white)
    end

    it 'promotes pawn to rook' do
      board.promo_pawn('a8', 'R')

      expect(board.grid['a8']).to be_a(Rook)
    end

    it 'promotes pawn to bishop' do
      board.promo_pawn('a8', 'B')

      expect(board.grid['a8']).to be_a(Bishop)
    end

    it 'promotes pawn to knight' do
      board.promo_pawn('a8', 'N')

      expect(board.grid['a8']).to be_a(Knight)
    end
  end

  describe '#serialize' do
    it 'returns board data in serializable format' do
      board.grid['a1'] = Rook.new(:white)
      board.grid['e8'] = King.new(:black)

      data = board.serialize

      expect(data['white_king_pos']).to eq(board.white_king_pos)
      expect(data['black_king_pos']).to eq(board.black_king_pos)

      expect(data['grid']['a1']).to eq('white_rook')
      expect(data['grid']['e8']).to eq('black_king')
    end
  end

  describe '#deserialize' do
    it 'restores board state from serialized data' do
      data = {
        'white_king_pos' => 'e1',
        'black_king_pos' => 'e8',
        'grid' => {
          'a1' => 'white_rook',
          'e8' => 'black_king'
        }
      }

      board.deserialize(data)

      expect(board.white_king_pos).to eq('e1')
      expect(board.black_king_pos).to eq('e8')

      expect(board.grid['a1']).to be_a(Rook)
      expect(board.grid['a1'].color).to eq(:white)

      expect(board.grid['e8']).to be_a(King)
      expect(board.grid['e8'].color).to eq(:black)
    end
  end
end
