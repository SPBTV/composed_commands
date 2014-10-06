require 'composed_commands'

class StringGenerator < ComposedCommands::Command
  def execute(string)
    string
  end
end

class StringCapitalizer < ComposedCommands::Command
  def execute(text)
    text.upcase
  end
end

class StringMultiplier < ComposedCommands::Command
  attribute :multiplicator, Integer, default: '3'
  attribute :separator, String

  def execute(text)
    (Array(text) * multiplicator).join(separator)
  end
end

class FailingCommand < ComposedCommands::Command
  def execute
    fail! 'failure message'
    input
  end
end

class SucceedCommand < ComposedCommands::Command
  def execute
    success! 'successive result'
    fail! 'failure message'
  end
end


class ChunkyBaconCapitalizer < ComposedCommands::ComposedCommand
  use StringGenerator
  use StringCapitalizer
end

class ChunkyBaconCapitalizerWithMuliplication < ChunkyBaconCapitalizer
  use StringMultiplier
end

class CompoundCommandWithFailingCommand < ComposedCommands::ComposedCommand
  use FailingCommand
  use StringGenerator
end

class CompoundCommandWithSuccessCommand < ComposedCommands::ComposedCommand
  use SucceedCommand
  use StringGenerator
end

class ConfigurableChunkyBaconProcessor < ComposedCommands::ComposedCommand
  use StringGenerator
  use StringMultiplier, multiplicator: 2, separator: '|'
end
