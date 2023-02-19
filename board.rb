# frozen_string_literal: true

# contains the board formatting, game rules checks, etc
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(9) { Array.new(9, 0) }
  end

  # create board
  def create_board
    convert_board_array_to_tiles
    fill_diagonal
    fill_remaining
    remove_some_numbers
  end

  def convert_board_array_to_tiles
    # map through elements of board & replace each element w/ tile instance
    @board.each_with_index do |line, i|
      line.each_with_index do |_char, j|
        @board[i][j] = Tile.new(@board[i][j], true, true)
      end
    end
  end

  def fill_diagonal
    [0, 3, 6].each do |i|
      fill_box(i, i)
    end
  end

  def fill_box(row, col)
    3.times do |i|
      3.times do |j|
        loop do
          num = [*1..9].sample
          break if unused_in_box(row, col, num)
        end
        @board[row + i][col + j].value = num
        @board[row + i][col + j].playable = false
      end
    end
  end

  def fill_remaining(row = 0, col = 3)
    # Check for the end of the box
    return true if row == 8 && col == 9

    # if it is the end of the current row, move to the next row
    if row == 9
      row += 1
      col = 0
    end
    # Skip filled spots
    return fill_remaining(row, col + 1) if @board[row][col].value != 0

    # fill cells
    fill_cells(row, col)
    false
  end

  def fill_cells(row, col)
    (1..9).each do |num|
      next unless check_if_safe_move(row, col, num)

      @board[row][col].value = num
      @board[row][col].playable = false

      return true if fill_remaining(row, col + 1)

      @board[row][col].value = 0
    end
  end

  # remove numbers for playing purpose
  def remove_some_numbers
    count = 50

    while count != 0
      i = rand(-1..7)
      j = rand(-1..7)
      next unless @board[i][j].value != 0

      count -= 1
      @board[i][j].value = 0
      @board[i][j].playable = true
    end
    @board
  end

  def check_if_safe_move(row, col, num)
    (unused_in_row(row, num) and unused_in_col(col, num) and unused_in_box(row - row % 3, col - col % 3, num))
  end

  def unused_in_row(row, num)
    9.times do |col|
      return false if @board[row][col].value == num
    end
    true
  end

  def unused_in_col(col, num)
    9.times do |row|
      return false if @board[row][col].value == num
    end
    true
  end

  def unused_in_box(row_start, col_start, num)
    3.times do |i|
      3.times do |j|
        return false if @board[row_start + i][col_start + j].value == num
      end
    end
    true
  end
end
