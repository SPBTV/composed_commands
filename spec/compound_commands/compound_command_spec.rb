require 'spec_helper'

RSpec.describe CompoundCommands::CompoundCommand do
  let(:input) { double(:input) }
  subject(:command) { CompoundCommands::Command.new(input) }

  context '.use' do
    let(:the_first) do
      Class.new(CompoundCommands::Command)
    end

    let(:the_second) do
      Class.new(CompoundCommands::Command)
    end

    subject(:compound_command) do
      commands = [the_first, the_second]

      Class.new(described_class) do
        use commands.first
        use commands.last
      end
    end

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
