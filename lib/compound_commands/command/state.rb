require 'workflow'

module CompoundCommands
  class Command
    class State
      include Workflow
      workflow do
        state :initialized do
          event :fail,    transitions_to: :failed
          event :success, transitions_to: :succeed
        end
        state :failed
        state :succeed
      end
    end
  end
end
