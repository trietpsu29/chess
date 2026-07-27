require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'
require_relative 'piece'

class Board
  attr_accessor :grid, :white_king_pos, :black_king_pos

  def initialize
    @white_king_pos = 'e1'
    @black_king_pos = 'e8'
    @grid = default_board
    setup_piece
  end

  def check_block_move?(start, des)
    start_col = start[0].ord
    des_col = des[0].ord
    start_row = start[1].to_i
    des_row = des[1].to_i

    factor_col = start_row < des_row ? 1 : -1
    factor_row = start_col < des_col ? 1 : -1
    factor_dig = start_col != des_col && start_row != des_row ? true : false
    curr_col = start_col
    curr_row = start_row
    loop do
      curr_row += factor_col if start_col == des_col || factor_dig
      curr_col += factor_row if start_row == des_row || factor_dig
      curr = @grid["#{curr_col.chr}#{curr_row}"]
      break if curr_col == des_col && curr_row == des_row
      return true unless curr.nil?
    end
    false
  end

  def check_inside_move?(start, des)
    return false unless start.length == 2
    return false unless des.length == 2

    ('a'..'h').include?(start[0]) &&
      ('1'..'8').include?(start[1]) &&
      ('a'..'h').include?(des[0]) &&
      ('1'..'8').include?(des[1])
  end

  def check_valid_move?(player, start, des)
    start_v = @grid[start]
    des_v = @grid[des]
    return false unless check_inside_move?(start, des)

    return false if start_v.nil?
    return false if start == des
    return false if start_v.color != player

    des_color = des_v.nil? ? nil : des_v.color
    return false if start_v.color == des_color
    return false unless start_v.check_piece_move?(start, des, des_color)
    return false if !start_v.is_a?(Knight) && check_block_move?(start, des)

    true
  end

  def move_piece(start, des)
    @grid[des] = @grid[start]
    @grid[start] = nil

    @white_king_pos = des if @grid[des].is_a?(King) && grid[des].color == :white
    @black_king_pos = des if @grid[des].is_a?(King) && grid[des].color == :black
  end

  def clear
    @grid = default_board
  end

  def display
    8.downto(1) do |row|
      print "#{row} "

      ('a'..'h').each do |col|
        piece = @grid["#{col}#{row}"]

        if piece.nil?
          print '. '
        else
          print "#{piece.symbol} "
        end
      end

      puts
    end

    print '  '
    ('a'..'h').each { |col| print "#{col} " }
    puts
  end

  def check_kingside_castling?(player)
    empty_space = player == :white ? %w[f1 g1] : %w[f8 g8]
    rook_pos = player == :white ? 'h1' : 'h8'

    return false unless empty_space.all? { |n| @grid[n].nil? }
    return false unless @grid[rook_pos].is_a?(Rook)

    true
  end

  def check_queenside_castling?(player)
    empty_space = player == :white ? %w[b1 c1 d1] : %w[b8 c8 d8]
    rook_pos = player == :white ? 'a1' : 'a8'

    return false unless empty_space.all? { |n| @grid[n].nil? }
    return false unless @grid[rook_pos].is_a?(Rook)

    true
  end

  def kingside_castling(player)
    cur_king_pos = player == :white ? 'e1' : 'e8'
    curr_rook_pos = player == :white ? 'h1' : 'h8'
    next_king_pos = player == :white ? 'g1' : 'g8'
    next_rook_pos = player == :white ? 'f1' : 'f8'

    move_piece(cur_king_pos, next_king_pos)
    move_piece(curr_rook_pos, next_rook_pos)
  end

  def queenside_castling(player)
    cur_king_pos = player == :white ? 'e1' : 'e8'
    curr_rook_pos = player == :white ? 'a1' : 'a8'
    next_king_pos = player == :white ? 'c1' : 'c8'
    next_rook_pos = player == :white ? 'd1' : 'd8'

    move_piece(cur_king_pos, next_king_pos)
    move_piece(curr_rook_pos, next_rook_pos)
  end

  private

  def default_board
    board = {}
    ('a'..'h').each do |col|
      (1..8).each do |row|
        board["#{col}#{row}"] = nil
      end
    end
    board
  end

  def setup_piece
    @grid[:a8] = Rook.new(:black)
    @grid[:b8] = Knight.new(:black)
    @grid[:c8] = Bishop.new(:black)
    @grid[:d8] = Queen.new(:black)
    @grid[:e8] = King.new(:black)
    @grid[:f8] = Bishop.new(:black)
    @grid[:g8] = Knight.new(:black)
    @grid[:h8] = Rook.new(:black)

    @grid[:a1] = Rook.new(:white)
    @grid[:b1] = Knight.new(:white)
    @grid[:c1] = Bishop.new(:white)
    @grid[:d1] = Queen.new(:white)
    @grid[:e1] = King.new(:white)
    @grid[:f1] = Bishop.new(:white)
    @grid[:g1] = Knight.new(:white)
    @grid[:h1] = Rook.new(:white)

    ('a'..'h').each do |file|
      @grid[:"#{file}2"] = Pawn.new(:white)
      @grid[:"#{file}7"] = Pawn.new(:black)
    end
  end
end
