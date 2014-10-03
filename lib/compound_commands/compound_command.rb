require 'compound_commands/command'

module CompoundCommands
  class CompoundCommand < Command

    def self.inherited(subclass)
      self.commands.each do |command|
        subclass.use command
      end
    end

    def self.commands
      Array(@commands)
    end

    def self.use(command_class)
      (@commands ||= []).push(command_class)
    end
  end
end
