require 'spec_helper'

RSpec.describe ComposedCommands::ComposedCommand, 'attributes' do
  let(:input) { 'chunky bacon' }

  subject(:command) { ConfigurableChunkyBaconProcessor.new }

  it 'count attributes, passed to StringMultiplier' do
    command.perform(input)
    expect(command.result).to eq "#{input}|#{input}"
  end
end
