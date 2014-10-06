require "compound_commands/version"
require 'active_support/dependencies/autoload'

module CompoundCommands
  extend ActiveSupport::Autoload

  autoload :Command
  autoload :CompoundCommand
end

