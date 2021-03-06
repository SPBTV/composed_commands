require 'composed_commands/command'

module ComposedCommands
  class ComposedCommand < Command

    def self.commands
      inherited_commands = if self.superclass.respond_to?(:commands)
        self.superclass.commands
      else
        []
      end
      Array(inherited_commands) + Array(@commands)
    end

    def self.use(klass, options = {})
      (@commands ||= []).push(ComposedCommands::CommandFactory.new(klass, options))
    end

    def commands
      self.class.commands.map do |command_factory|
        command = command_factory.create
        before_execute(command) if respond_to? :before_execute
        command
      end
    end

    protected
    def execute(*args)
      commands.inject(args) do |data, command|
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
