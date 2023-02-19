# frozen_string_literal: true

require 'spec_helper'
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
end
