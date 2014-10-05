require 'spec_helper'

RSpec.describe CompoundCommands::Command do
  let(:string) { 'Chunky Bacon' }
  let(:execution) { CompoundCommands::Command::Execution.new }
  let(:state) { CompoundCommands::Command::State.new }

  subject(:command) { StringCapitalizer.new(string) }

  context 'delagations' do
    before do
      command.execution = execution
      command.state = state
    end

    it 'delegate #interrupted? to #execution' do
      expect(execution).to receive(:interrupted?)

      command.halted?
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
      expect(command).to receive(:execute).and_wrap_original do |method, *args|
        expect(command.execution).to be_performing
        expect(command.state).to be_undefined

        method.call(*args)
      end
    end

    before :example do
      expect(command.execution).to be_pending
      expect(command.state).to be_undefined
    end

    after :example do
      expect(command.execution).to be_performed
      expect(command.state).to be_succeed
    end

    it 'yield result' do
      res = command.perform(string)
      expect(res).to eq command
      expect(command.result).to eq 'CHUNKY BACON'
    end
  end

  context '#fail!' do
    subject(:failing_command) { FailingCommand.new }

    before :example do
      failing_command.perform
    end

    it { expect(failing_command.result).to be_nil }
    it { expect(failing_command.message).to eq 'failure message' }
    it { expect(failing_command).to be_failed }
    it { expect(failing_command).to be_halted }
    it { expect(failing_command).not_to be_succeed }
  end

  context '#success!' do
    subject(:succeed_command) { SucceedCommand.new }

    before :example do
      succeed_command.perform
    end

    it { expect(succeed_command.result).to eq 'successive result' }
    it { expect(succeed_command.message).to be_nil }
    it { expect(succeed_command).not_to be_failed }
    it { expect(succeed_command).to be_halted }
    it { expect(succeed_command).to be_succeed }
  end
end
