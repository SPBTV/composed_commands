# ComposedCommands

Composed Commands is a tool set for creating commands and assembling
multiple of these commands in operation pipelines. A command is, at its
core, an implementation of the [strategy
pattern](http://en.wikipedia.org/wiki/Strategy_pattern) and in this sense an
encapsulation of an algorithm. An operation pipeline is an assembly of multiple
commands and useful for implementing complex algorithms. Pipelines themselves
can be part of other pipelines.

## Installation

Add this line to your application's Gemfile:

    gem 'composed_commands'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install composed_commands

## Usage

Operations can be defined by subclassing `ComposedCommands::Command` and
operation pipelines by subclassing `ComposedCommands::ComposedCommand`.

### Defining an Command

To define an command, two steps are necessary:

1. create a new subclass of `ComposedCommands::Command`, and
2. implement the `#execute` method.

The listing below shows an operation that extracts a timestamp in the format
`yyyy-mm-dd` from a string.

```ruby
class DateExtractor < ComposedCommands::Command
  def execute(text)
    text.scan(/(\d{4})-(\d{2})-(\d{2})/)
  end

end
```

There are two ways to execute this operation:

1. create a new instance of this command and call `#perform`, or
2. directly call `.perform` on the command class.

Please note that directly calling the `#execute`
method is prohibited. To enforce this constraint, the method is automatically
marked as protected upon definition.

The listing below demonstrates how to execute the command defined above.

```ruby
text = "This gem was first published on 2013-06-10."

extractor = DateExtractor.new
extractor.perform(text) # => [["2013", "06", "10"]]

DateExtractor.perform(text) # => [["2013", "06", "10"]]
```

### Defining an Command Pipeline

Assume that we are provided a command that converts these arrays of strings
into actual `Time` objects. The following listing provides a potential
implementation of such an operation.

```ruby
class DateArrayToTimeObjectConverter < ComposedCommands::Command

  def execute(collection_of_date_arrays)
    collection_of_date_arrays.map do |date_array|
      Time.new(*(date_array.map(&:to_i)))
    end
  end

end
```

Using these two commands, it is possible to create a composed command that
extracts dates from a string and directly converts them into `Time` objects. To
define a composed command, two steps are necessary:

1. create a subclass of `ComposedCommands::ComposedCommand`, and
2. use the macro method `use` to assemble the command.

The listing below shows how to assemble the two commands, `DateExtractor` and
`DateArrayToTimeObjectConverter`, into a composed command named `DateParser`.

```ruby
class DateParser < ComposedCommands::ComposedCommand

  use DateExtractor
  use DateArrayToTimeObjectConverter

end
```

Composed commands provide the same interface as normal commands. Hence,
they can be invoked the same way. For the sake of completeness, the listing
below shows how to use the `DateParser` operation.

```ruby
text = "This gem was first published on 2013-06-10."

parser = DateParser.new
parser.perform(text) # => 2013-06-07 00:00:00 +0200

DateParser.perform(text) # => 2013-06-07 00:00:00 +0200
```

### Control Flow

A command can be *aborted* if a successful execution is not
possible. The listing below provides examples on how to access an command's state.

```ruby
class StrictDateParser < DateParser

  def execute
    result = super
    fail! "no timestamp found" if result.empty?
    result
  end

end

parser = StrictDateParser.new
parser.perform("")
parser.message # => "no timestamp found"
parser.succeed? # => false
parser.failed? # => true
```

### Configuring Commands

Commands and composed commands support
[Virtus](https://github.com/solnic/virtus) to conveniently
provide additional settings upon initialization of a command. In the
example below, a command is defined that indents a given string. The indent
is set to 2 by default but can easily be changed by supplying an options hash
to the initializer.

```ruby
class Indention < ComposedCommands::Command
  attribute :indent, Integer, default: 2, required: true

  def execute(text)
    text.split("\n").map { |line| " " * indent + line }.join("\n")
  end

end

command = Indention.perform("Hello World", indent: 4)
command.result = # => "    Hello World"
```

Commands that are part of a composed command can be configured by calling
the `.use` method with a hash of options as the second argument. See the
listing below for an example.

```ruby
class SomeComposedCommand < ComposedCommands::ComposedCommand

  # ...
  use Indention, indent: 4
  # ...

 end
```

You can configure part of Composed Command at runtime using `before_execute` callback':

```ruby
class AbilityChecker < ComposedCommands::ComposedCommand
  attribute :user, User, require: true

  use Presence
  use RegisteredAt, after: '2010-10-10
  use Admin
  # ...

  def before_execute(command)
    command.user = user
  end
end

ability = AbilityChecker.new(user: current_user)
ability.perform(post)
```

This gem based on [Composable Operations](https://github.com/t6d/composable_operations) written by Konstantin Tennhard

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

##License

Copyright 2014 SPB TV AG

Licensed under the Apache License, Version 2.0 (the ["License"](LICENSE)); you may not use this file except in compliance with the License.

You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 

See the License for the specific language governing permissions and limitations under the License.

