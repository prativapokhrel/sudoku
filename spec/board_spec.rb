# frozen_string_literal: true

require_relative '../game'

describe '#board_spec' do
  before(:each) do
    @board = Board.new
  end

  describe '#update_board' do
    before do
      @board.create_board
      @row, @row_num = row_tiles_and_num(@board)
      @row_digits = row_digits(@row)
      @fillable_spots = fillable_spots(@row)
      @unfillable_spots = unfillable_spots(@fillable_spots)
      @playable_nums = playable_nums(@row_digits) &
                       non_box_nums(@row_num, @fillable_spots[0]) &
                       playable_nums_in_col(@fillable_spots[0], @board)
    end

    it 'does not repeat the digits' do
      expect(@row_digits.uniq.length).to eq(@row_digits.length)
    end

    it 'checks safe move' do
      expect(@row_digits.uniq.length).to eq(@row_digits.length)
      expect(@board.update_board(@row_num.to_s + @fillable_spots[0].to_s +
                                 @playable_nums[0].to_s)).to eq(@playable_nums[0])
      expect(@board.board[@row_num][@fillable_spots[0]].safe_move).to eq(true)

      expect(@board.update_board(@row_num.to_s + @fillable_spots[0].to_s +
                                 @row_digits[0].to_s)).to eq(@row_digits[0])
      expect(@board.board[@row_num][@fillable_spots[0]].safe_move).to eq(false)
    end

    it 'checks valid user input' do
      expect(@board.valid_user_input?(@row_num.to_s + @fillable_spots[0].to_s +
                                      @playable_nums[0].to_s)).to eq(true)
      expect(@board.valid_user_input?(@row_num.to_s + @unfillable_spots[0].to_s +
                                      @playable_nums[0].to_s)).to eq(false)
    end
  end

  def row_tiles_and_num(board)
    9.times do |i|
      row = board.board[i]
      row_sum = row.inject(0) { |sum, tile| sum + tile.value }
      return row, i if row_sum > 0 && row_sum != [1..9].inject(:+)
    end
  end

  def row_digits(row)
    row.map { |tile| tile.value unless tile.value.zero? }.compact.shuffle
  end

  def playable_nums(row_digits)
    nums = [*1..9] - row_digits
    nums.shuffle
  end

  def fillable_spots(row)
    row.map.with_index { |spot, index| index if spot.playable }.compact.shuffle
  end

  def unfillable_spots(fillable_spots)
    unfillable_spots = [*0..8] - fillable_spots
    unfillable_spots.shuffle
  end

  def non_box_nums(row_start, col_start)
    row_start -= row_start % 3
    col_start -= col_start % 3
    nums = []
    3.times do |i|
      3.times do |j|
        nums << @board.board[row_start + i][col_start + j].value
      end
    end
    [*1..9] - nums
  end

  def playable_nums_in_col(col, board)
    nums = []
    9.times do |row|
      nums << board.board[row][col].value
    end
    ([*1..9] - nums)
  end
end
