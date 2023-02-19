# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

# tiles for managing display
class Tile
  attr_accessor :playable, :value, :safe_move

  def initialize(value, playable, safe_move)
    @value = value
    @playable = playable
    @safe_move = safe_move
  end

  def colorize
    if @playable && @safe_move
      " #{@value} ".colorize(color: black, background: light_cyan)
    elsif !@safe_move
      " #{@value} ".colorize(color: white, background: red)
    else
      " #{@value} ".colorize(color: black, background: white)
    end
  end
end
