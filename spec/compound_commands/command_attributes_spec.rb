require 'spec_helper'

RSpec.describe ChainableCommands::Command, 'attributes' do
  let(:string) { 'chunky bacon' }
  subject(:command) { StringMultiplier.new(separator: '/') }

  it 'initialize attributes' do
    command.perform(string)
    expect(command.result).to eq "#{string}/#{string}/#{string}"
  end
end
