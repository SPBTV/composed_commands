module CompoundCommands
  class CommandFactory
    attr_reader :command
    def initialize(command, options = {})
      @command = command
      @options = options
    end

    def create
      @command.new(@options)
    end
  end
end
