require 'spec_helper'

RSpec.describe CompoundCommands::Command::Processes do
  StringGenerator.processes :dink, :another_drink

  it 'raises error if no arguments given' do
    expect {
      StringGenerator.processes
    }.to raise_error(ArgumentError, 'StringGenerator.processes expects at least one argument')
  end

  subject(:command) { StringGenerator.new('whiskey', 'coke') }

  it 'first argument available' do
    expect(command.dink).to eq 'whiskey'
  end

  it 'second argument available' do
    expect(command.another_drink).to eq 'coke'
  end
end
