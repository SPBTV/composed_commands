require 'compound_commands/command'

module CompoundCommands
  class CompoundCommand < Command
    def self.commands
      inherited_commands = if self.superclass.respond_to?(:commands)
        self.superclass.commands
      else
        []
      end
      Array(inherited_commands) + Array(@commands)
    end

    def self.use(command_class)
      (@commands ||= []).push(command_class)
    end

    protected
    def execute(*args)
      self.class.commands.inject(args) do |data, command_class|
        command = command_class.new
        command.perform(*Array(data))

        if command.halted?
          case
          when command.failed?
            fail! command.message
          when command.succeed?
            success! command.result
          else
            raise "Unexpected state for interrupted command: `#{command.current_state.name}`"
          end
        end

        command.result
      end
    end
  end
end
