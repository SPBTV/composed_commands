require 'workflow'
require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'

module ChainableCommands
  class Command
    class Execution
      include Workflow
      workflow do
        state :pending do
          event :perform,   transitions_to: :performing
        end
        state :performing do
          event :interrupt, transitions_to: :interrupted
          event :done,      transitions_to: :performed
        end
        state :interrupted
        state :performed
      end
    end
  end
end
