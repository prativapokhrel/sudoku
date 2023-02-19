# frozen_string_literal: true

require 'pry'
require_relative './board'

# program to start and play sudoku
class Game
  def initialize
    @game_board = Board.new
  end

  def start_game
    ask_user_to_start_game
    load_new_game_board
    @game_board.play_round until @game_board.solved?
    @game_board.render_board(@game_board.board)
    winning_message if @game_board.solved?
  end

  def ask_user_to_start_game
    print "\nLet's play Sudoku!\n\n"
    print 'Are you ready? (Y/N): '
    user_input_start_game = gets.chomp
    puts(user_input_start_game)

    if valid_start_game_input?(user_input_start_game)
      print "Great, let's get started!\n"
    else
      abort("Mission abort!!!!!!, BYE \n")
    end
  end

  def valid_start_game_input?(input)
    input.upcase == 'Y'
  end

  # load board
  def load_new_game_board
    @game_board.create_board
  end

  def winning_message
    print "\n\n*Congratulations!!!\nYou've won the game!\n"
  end
end

if __FILE__ == 'game.rb'
  g = Game.new
  g.start_game
end
