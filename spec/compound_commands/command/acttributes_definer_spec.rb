require 'spec_helper'

RSpec.describe CompoundCommands::Command::AttributesDefiner do
  let(:required) { double('required') }
  let(:optional) { double('optional') }
  let(:rest) { [double('optional 1'), double('optional 2')] }
  let(:block) { lambda {} }

  let(:test_class) do
    Class.new do
      include CompoundCommands::Command::AttributesDefiner
      def test(required, optional = 42, *rest, &block)
      end
    end
  end

  context 'define argument readers for' do
    before :example do
      subject.send :define_attributes, :test, [required, optional, rest, block]
    end

    subject { test_class.new }

    it 'required argument' do
      expect(subject.send :required).to eq required
    end

    it 'optional argument' do
      expect(subject.send :optional).to eq optional
    end

    it 'star arguments' do
      expect(subject.send :rest).to eq rest
    end

    it 'block' do
      expect(subject.send :block).to eq block
    end
  end
end
