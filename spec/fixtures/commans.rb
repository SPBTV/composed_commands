require 'compound_commands'

class StringGenerator < CompoundCommands::Command
  def execute(string)
    string
  end
end

class StringCapitalizer < CompoundCommands::Command
  def execute(text)
    text.upcase
  end
end

class StringMultiplier < CompoundCommands::Command
  def execute(text)
    multiplicator = 3
    separator = ' '
    (Array(text) * multiplicator).join(separator)
  end
end

class FailingCommand < CompoundCommands::Command
  def execute
    fail! 'failure message'
    input
  end
end

class SucceedCommand < CompoundCommands::Command
  def execute
    success! 'successive result'
    fail! 'failure message'
  end
end


class ChunkyBaconCapitalizer < CompoundCommands::CompoundCommand
  use StringGenerator
  use StringCapitalizer
end

class ChunkyBaconCapitalizerWithMuliplication < ChunkyBaconCapitalizer
  use StringMultiplier
end

class CompoundCommandWithFailingCommand < CompoundCommands::CompoundCommand
  use FailingCommand
  use StringGenerator
end

class CompoundCommandWithSuccessCommand < CompoundCommands::CompoundCommand
  use SucceedCommand
  use StringGenerator
end
