require 'spec_helper'

RSpec.describe CompoundCommands::Command do
  let(:input) { double(:input) }
  let(:execution) { double('execution') }
  subject(:command) { CompoundCommands::Command.new(input) }

  it '#input' do
    expect(command.input).to contain_exactly input
  end

  it 'delegte #interrupted? to execution' do
    command.execution = execution
    expect(execution).to receive(:interrupted?)

    command.interrupted?
  end
end
