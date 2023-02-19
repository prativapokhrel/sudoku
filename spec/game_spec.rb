# frozen_string_literal: true

require 'spec_helper'
require_relative '../game'

describe '#game' do
  let(:game) { Game.new }
  let(:game_board) { Board.new }

  context 'ask_user_to_start_game' do
    it 'does not raise error when user inputs Y' do
      allow(game).to receive(:gets).and_return('Y')
      expect { game.ask_user_to_start_game }.not_to raise_error
    end

    it 'raises error when user inputs N or any other character' do
      allow(game).to receive(:gets).and_return('N')
      expect { game.ask_user_to_start_game }.to raise_error(SystemExit)

      allow(game).to receive(:gets).and_return('?')
      expect { game.ask_user_to_start_game }.to raise_error(SystemExit)
    end
  end

  context '#load_new_game' do
    before do
      allow(game).to receive(:gets).and_return('Y')
    end
    it 'creates 9x9 box' do
      expect(game.load_new_game_board).to include(Array)
      output_array = game.load_new_game_board
      expect(output_array.length).to eq(9)
      expect(output_array[0].length).to eq(9)
    end
  end
end
