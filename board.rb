# frozen_string_literal: true

require 'colorize'
require 'colorized_string'
require './tile'
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
    (unused_in_row(row, num) and unused_in_col(col, num) and unused_in_box(row - (row % 3), col - (col % 3), num))
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

  # GET USER INPUT
  def ask_user_input
    print "\nEnter you move (e.g. 001 => [0,0], 1)\n"
    user_input = gets.chomp
    if valid_user_input?(user_input)
      user_input
    else
      print 'Please enter a valid move..'
      ask_user_input
    end
  end

  def format_user_input(user_input)
    int_input = user_input.chars.map(&:to_i)
    [[int_input[0], int_input[1]], int_input[2]]
  end

  # Validate move
  def valid_user_input?(user_input)
    unless user_input.empty?
      formatted_input = format_user_input(user_input)
      return true if valid_input_length_and_chars?(formatted_input) && playable_move?(formatted_input)
    end
    false
  end

  # => [[0, 1], 1]
  def valid_input_length_and_chars?(formatted_input)
    input_length_two = (formatted_input.length == 2)
    input_is_array = formatted_input.is_a?(Array)
    value_is_int = formatted_input[1].is_a?(Integer)

    input_length_two && input_is_array && pos_as_array_and_length_two(formatted_input) &&
      pos_values_in_range(formatted_input) && value_is_int && value_in_range(formatted_input)
  end

  def pos_as_array_and_length_two(formatted_input)
    formatted_input[0].is_a?(Array) && formatted_input[0].length == 2
  end

  def pos_values_in_range(formatted_input)
    formatted_input[0][0] >= 0 && formatted_input[0][0] <= 8 &&
      formatted_input[0][1] >= 0 && formatted_input[0][1] <= 8
  end

  def value_in_range(formatted_input)
    formatted_input[1] >= 1 && formatted_input[1] <= 9
  end

  # => [[0,1], 4]
  def playable_move?(player_move)
    position = player_move[0]
    @board[position[0]][position[1]].playable
  end

  def solved?
    @board.flatten.all? { |a| !a.value.zero? && a.safe_move }
  end

  def update_board(user_input)
    formatted_input = format_user_input(user_input)
    player_input_value = formatted_input[1]

    board_position = convert_input_to_board_position(formatted_input)

    board_position.safe_move = if check_if_safe_move(user_input[0].to_i, user_input[1].to_i, user_input[-1].to_i)
                                 true
                               else
                                 false
                               end
    board_position.value = player_input_value
  end

  # => [[0, 1], 4]
  def convert_input_to_board_position(input)
    position = input[0]
    @board[position[0]][position[1]]
  end
end
