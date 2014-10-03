require 'spec_helper'

RSpec.describe CompoundCommands::Command do
  let(:input) { double(:input) }
  let(:execution) { CompoundCommands::Command::Execution.new(command) }
  let(:state) { CompoundCommands::Command::State.new }
  subject(:command) { CompoundCommands::Command.new(input) }

  it '#input' do
    expect(command.input).to contain_exactly input
  end

  context 'delagations' do
    before do
      command.execution = execution
      command.state = state
    end

    it 'delegate #interrupted? to #execution' do
      expect(execution).to receive(:interrupted?)

      command.interrupted?
    end

    it 'delegate #failed? to #state' do
      expect(state).to receive(:failed?)

      command.failed?
    end

    it 'delegate #succeed? to #state' do
      expect(state).to receive(:succeed?)

      command.succeed?
    end

    it 'delegate #current_state to #state' do
      expect(state).to receive(:current_state)

      command.current_state
    end
  end
end
