# frozen_string_literal: true

# helper for board spec
class BoardSpecHelper
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
