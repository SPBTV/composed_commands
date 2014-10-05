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

    def initialize(*args)
      @input = args
      @execution = Execution.new
      @state = State.new
    end

    def perform
      @result = catch(:halt) do
        execution.perform!
        result = execute
        state.success!
        execution.done!
        result
      end
    end


    def halted?
      execution.interrupted?
    end

    protected

    def execute
      raise NotImplementedError, "#{self.class.name}#execute not implemented"
    end

    def fail!(message)
      # TODO: Move message to result?
      @message = message
      state.fail!
      execution.interrupt!
      throw :halt
    end

    def success!(result)
      state.success!
      execution.interrupt!
      throw :halt, result
    end
  end
end
