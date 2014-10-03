require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'

module CompoundCommands
  class Command
    extend ActiveSupport::Autoload
    autoload :Execution
    autoload :State

    attr_reader :input
    attr_accessor :execution
    attr_accessor :state
    delegate :failed?, :succeed?, :current_state, to: :state
    delegate :interrupted?, to: :execution

    def initialize(*args)
      @input = args
      @execution = Execution.new(self)
      @state = State.new
    end

    protected

    def interrupt(result = nil)
    end
  end
end
