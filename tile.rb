# frozen_string_literal: true

#tiles for managing display
class Tile
  attr_accessor :playable
  attr_accessor :value
  attr_accessor :safe_move


  def initialize(value, playable, safe_move)
    @value = value
    @playable = playable
    @safe_move = safe_move 
  end
end
