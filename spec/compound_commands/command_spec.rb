require 'spec_helper'

RSpec.describe CompoundCommands::Command do
  let(:input) { double(:input) }
  subject { CompoundCommands::Command.new(input) }

  it '#input' do
    expect(subject.input).to contain_exactly input
  end
end
