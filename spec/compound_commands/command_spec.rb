require 'spec_helper'

RSpec.describe CompoundCommands::Command do
  let(:input) { double(:input) }
  let(:execution) { CompoundCommands::Command::Execution.new }
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

  context '#perform' do
    before :example do
      expect(command).to receive(:execute) do |*args|
        expect(command.execution).to be_performing
        expect(command.state).to be_initialized
        'result'
      end
    end

    before :example do
      expect(command.execution).to be_initialized
      expect(command.state).to be_initialized
    end

    after :example do
      expect(command.execution).to be_performed
      expect(command.state).to be_succeed
    end

    it 'yield result' do
      command.perform
      expect(command.result).to eq 'result'
    end
  end

  context '#fail!' do
    subject(:failing_command) do
      def command.execute
        fail! 'failure message'
        'result'
      end
      command
    end

    before :example do
      failing_command.perform
    end

    it { expect(failing_command.result).to be_nil }
    it { expect(failing_command.message).to eq 'failure message' }
    it { expect(failing_command).to be_failed }
    it { expect(failing_command).to be_interrupted }
    it { expect(failing_command).not_to be_succeed }
  end

  context '#success!' do
    subject(:succeed_command) do
      def command.execute
        success! 'result'
        fail! 'failure message'
      end
      command
    end

    before :example do
      succeed_command.perform
    end

    it { expect(succeed_command.result).to eq 'result' }
    it { expect(succeed_command.message).to be_nil }
    it { expect(succeed_command).not_to be_failed }
    it { expect(succeed_command).to be_interrupted }
    it { expect(succeed_command).to be_succeed }
  end
end
