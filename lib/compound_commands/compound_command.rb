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
    def execute
      self.class.commands.inject(input) do |data, command_class|
        command = build_command(command_class, data)
        command.perform

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

    def build_command(klass, data)
      if data.respond_to?(:to_ary)
        klass.new(*data)
      else
        klass.new(data)
      end
    end
  end
end
