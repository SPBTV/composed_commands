require 'spec_helper'

RSpec.describe CompoundCommands::Command::Execution do
  let(:command) { CompoundCommands::Command.new }

  subject(:execution) { described_class.new(command) }

  context '#interrupt!' do
    before do
      execution.perform!
    end

    it 'delegates #interrupt method' do
      expect(command).to receive(:interrupt)

      execution.interrupt!
    end
  end
end
