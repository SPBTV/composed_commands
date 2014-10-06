require "composed_commands/version"
require 'active_support/dependencies/autoload'

module ComposedCommands
  extend ActiveSupport::Autoload

  autoload :Command
  autoload :CommandFactory
  autoload :ComposedCommand
end

