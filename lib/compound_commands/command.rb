require 'virtus'
require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'

module CompoundCommands
  class Command
    extend ActiveSupport::Autoload
    include Virtus.model
    autoload :Execution
    autoload :State

    attr_reader :result
    attr_reader :message
    attr_accessor :execution
    attr_accessor :state
    delegate :failed?, :succeed?, :current_state, to: :state

    def initialize(options = {})
      @execution = Execution.new
      @state = State.new

      super(options)
    end

    def perform(*args)
      @result = catch(:halt) do
        execution.perform!
        result = execute(*args)
        state.success!
        execution.done!
        result
      end
      self
    end

    def halted?
      execution.interrupted?
    end

    protected

    def execute(*_)
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
