require 'workflow'
require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'

module CompoundCommands
  class Command
    class Execution
      include Workflow
      workflow do
        state :initialized do
          event :perform,   transitions_to: :performing
        end
        state :performing do
          event :interrupt, transitions_to: :interrupted
          event :done,      transitions_to: :performed
        end
        state :interrupted
        state :performed
      end
      delegate :interrupt, to: :@command

      def initialize(command)
        @command = command
      end
    end
  end
end
