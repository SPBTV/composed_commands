# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'composed_commands/version'

Gem::Specification.new do |spec|
  spec.name          = 'composed_commands'
  spec.version       = ComposedCommands::VERSION
  spec.authors       = ['Tema Bolshakov']
  spec.email         = ['abolshakov@spbtv.com']
  spec.summary       = "Tool for creating commands and commands chains."
  spec.description   = "Tool for creating commands and commands chains."
  spec.homepage      = ""
  spec.license       = 'Apache License, Version 2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '~> 4'
  spec.add_runtime_dependency 'workflow', '~> 1'
  spec.add_runtime_dependency 'virtus', '~> 1'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
