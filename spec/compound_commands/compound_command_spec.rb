require 'spec_helper'

RSpec.describe CompoundCommands::CompoundCommand do
  let(:input) { 'chunky bacon' }

  context '#perfrorm' do
    it 'performs successfully' do
      command = ChunkyBaconCapitalizer.new(input)
      command.perform

      expect(command.result).to eq 'CHUNKY BACON'
      expect(command.message).to be_nil
      expect(command).not_to be_failed
      expect(command).not_to be_halted
      expect(command).to be_succeed
    end

    it 'performs with failure! in first command' do
      command = CompoundCommandWithFailingCommand.new

      command.perform

      expect(command.result).to be_nil
      expect(command.message).to eq 'failure message'
      expect(command).to be_failed
      expect(command).to be_halted
      expect(command).not_to be_succeed
    end

    it 'performs with success! in first command' do
      command = CompoundCommandWithSuccessCommand.new

      command.perform

      expect(command.result).to eq 'successive result'
      expect(command.message).to be_nil
      expect(command).not_to be_failed
      expect(command).to be_halted
      expect(command).to be_succeed
    end
  end

  context '.use' do
    subject(:command) { ChunkyBaconCapitalizer }
    it { expect(command.commands.size).to eq 2 }
    it { expect(command.commands.first).to eq StringGenerator }
    it { expect(command.commands.last).to eq StringCapitalizer }

    context 'inherited compound commands' do
      subject(:child_command) { ChunkyBaconCapitalizerWithMuliplication }

      it { expect(child_command.commands.size).to eq 3 }
      it { expect(child_command.commands[0]).to eq StringGenerator }
      it { expect(child_command.commands[1]).to eq StringCapitalizer }
      it { expect(child_command.commands[2]).to eq StringMultiplier }
    end
  end
end
