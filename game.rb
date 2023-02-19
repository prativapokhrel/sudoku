# frozen_string_literal: true

require 'pry'
require_relative './board'

# program to start and play sudoku
class Game
  def initialize
    @game_board = Board.new
  end

  def start_game
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
end

if __FILE__ == 'game.rb'
  g = Game.new
  g.start_game
end
