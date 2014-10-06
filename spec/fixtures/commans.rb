require 'chainable_commands'

class StringGenerator < ChainableCommands::Command
  def execute(string)
    string
  end
end

class StringCapitalizer < ChainableCommands::Command
  def execute(text)
    text.upcase
  end
end

class StringMultiplier < ChainableCommands::Command
  attribute :multiplicator, Integer, default: '3'
  attribute :separator, String

  def execute(text)
    (Array(text) * multiplicator).join(separator)
  end
end

class FailingCommand < ChainableCommands::Command
  def execute
    fail! 'failure message'
    input
  end
end

class SucceedCommand < ChainableCommands::Command
  def execute
    success! 'successive result'
    fail! 'failure message'
  end
end


class ChunkyBaconCapitalizer < ChainableCommands::ChainableCommand
  use StringGenerator
  use StringCapitalizer
end

class ChunkyBaconCapitalizerWithMuliplication < ChunkyBaconCapitalizer
  use StringMultiplier
end

class CompoundCommandWithFailingCommand < ChainableCommands::ChainableCommand
  use FailingCommand
  use StringGenerator
end

class CompoundCommandWithSuccessCommand < ChainableCommands::ChainableCommand
  use SucceedCommand
  use StringGenerator
end

class ConfigurableChunkyBaconProcessor < ChainableCommands::ChainableCommand
  use StringGenerator
  use StringMultiplier, multiplicator: 2, separator: '|'
end
