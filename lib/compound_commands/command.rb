module CompoundCommands
  class Command
    extend ActiveSupport::Autoload

    attr_reader :input
    def initialize(*args)
      @input = args
    end
  end
end
