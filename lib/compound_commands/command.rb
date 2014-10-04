require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'

module CompoundCommands
  class Command
    extend ActiveSupport::Autoload
    autoload :Execution
    autoload :State
    autoload :Processes
    extend Processes

    attr_reader :input
    attr_reader :result
    attr_reader :message
    attr_accessor :execution
    attr_accessor :state
    delegate :failed?, :succeed?, :current_state, to: :state
    delegate :interrupted?, to: :execution

    def initialize(*args)
      @input = args
      @execution = Execution.new
      @state = State.new
    end

    def perform
      @result = catch(:interrupt) do
        execution.perform!
        result = execute
        state.success!
        execution.done!
        result
      end
    end

    protected

    def execute
      raise NotImplementedError, "#{self.class.name}#execute not implemented"
    end

    def fail!(message)
      @message = message
      state.fail!
      execution.interrupt!
      throw :interrupt
    end

    def success!(result)
      state.success!
      execution.interrupt!
      throw :interrupt, result
    end
  end
end
