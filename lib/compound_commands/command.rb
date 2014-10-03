require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'

module CompoundCommands
  class Command
    extend ActiveSupport::Autoload
    autoload :Execution

    attr_reader :input
    attr_accessor :execution
    delegate :interrupted?, to: :@execution

    def initialize(*args)
      @input = args
      @execution  = Execution.new(self)
    end

    protected

    def interrupt(result = nil)
    end
  end
end
