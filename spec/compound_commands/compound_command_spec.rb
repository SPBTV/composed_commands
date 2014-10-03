require 'spec_helper'

RSpec.describe CompoundCommands::CompoundCommand do
  let(:input) { double(:input) }

  let(:the_first) do
    Class.new(CompoundCommands::Command) do
      def execute
        if input.include?(:fail)
          fail! 'failure message'
        elsif input.include?(:success)
          success! 'success result'
        end
      end
    end
  end

  let(:the_second) do
    Class.new(CompoundCommands::Command) do
      def execute
        'result'
      end
    end
  end

  subject(:compound_command) do
    commands = [the_first, the_second]

    Class.new(described_class) do
      use commands.first
      use commands.last
    end
  end

  context '#perfrorm' do
    it 'performs successfully' do
      command = compound_command.new(input)
      command.perform

      expect(command.result).to eq 'result'
      expect(command.message).to be_nil
      expect(command).not_to be_failed
      expect(command).not_to be_interrupted
      expect(command).to be_succeed
    end

    it 'performs with failure! in first command' do
      command = compound_command.new(:fail)

      command.perform

      expect(command.result).to be_nil
      expect(command.message).to eq 'failure message'
      expect(command).to be_failed
      expect(command).to be_interrupted
      expect(command).not_to be_succeed
    end

    it 'performs with success! in first command' do
      command = compound_command.new(:success)

      command.perform

      expect(command.result).to eq 'success result'
      expect(command.message).to be_nil
      expect(command).not_to be_failed
      expect(command).to be_interrupted
      expect(command).to be_succeed
    end
  end
  context '.use' do
    it { expect(compound_command.commands.size).to eq 2 }
    it { expect(compound_command.commands.first).to eq the_first }
    it { expect(compound_command.commands.last).to eq the_second }

    context 'inherited commands' do
      let(:the_zero) do
        Class.new(CompoundCommands::Command)
      end

      subject(:child_compound_command) do
        command = the_zero
        Class.new(compound_command) do
          use command
        end
      end

      it { expect(child_compound_command.commands.size).to eq 3 }
      it { expect(child_compound_command.commands[0]).to eq the_first }
      it { expect(child_compound_command.commands[1]).to eq the_second }
      it { expect(child_compound_command.commands[2]).to eq the_zero }
    end
  end
end
