require 'compound_commands'

class StringGenerator < CompoundCommands::Command
  def execute
    'chunky bacon'
  end
end

class StringCapitalizer < CompoundCommands::Command
  # processes :text

  def execute
    input.map(&:upcase)
  end
end

class StringMultiplier < CompoundCommands::Command
  def execute
    multiplicator = 3
    separator = ' '
    (Array(input) * multiplicator).join(separator)
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
