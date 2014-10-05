module CompoundCommands
  class Command
    module Processes
      def processes(*names)
        case names.length
        when 0
          raise ArgumentError, "#{self}.#{__callee__} expects at least one argument"
        else
          names.each_with_index do |name, index|
            define_method(name) do
              input[index]
            end
          end
        end
      end
    end
  end
end
