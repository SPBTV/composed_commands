require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/array/extract_options'

module CompoundCommands
  class Command
    extend ActiveSupport::Autoload
    autoload :Execution
    autoload :State
    include AttributesDefiner

    attr_reader :result
    attr_reader :message
    attr_accessor :execution
    attr_accessor :state
    delegate :failed?, :succeed?, :current_state, to: :state

    def initialize(*args)
      @options = args.extract_options!
      @input = args
      @execution = Execution.new
      @state = State.new
      define_attributes(:execute, args)
    end

    def perform
      @result = catch(:halt) do
        execution.perform!
        result = execute(*@input)
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
