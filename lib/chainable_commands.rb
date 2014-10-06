require "chainable_commands/version"
require 'active_support/dependencies/autoload'

module ChainableCommands
  extend ActiveSupport::Autoload

  autoload :Command
  autoload :ChainableCommand
end

