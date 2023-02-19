# frozen_string_literal: true

RSpec.configure do |config|
  config.color = true
  config.before(:each) do
    allow($stdout).to receive(:write)
    allow($stderr).to receive(:write)
  end
end
