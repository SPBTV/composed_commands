require 'workflow'

module ComposedCommands
  class Command
    class State
      include Workflow
      workflow do
        state :undefined do
          event :fail,    transitions_to: :failed
          event :success, transitions_to: :succeed
        end
        state :failed
        state :succeed
      end
    end
  end
end
