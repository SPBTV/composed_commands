module CompoundCommands
  class Command
    module AttributesDefiner
      private
      def define_attributes(method_name, args)
        parameters = method(method_name).parameters.map(&:last)
        parameters.zip(args).each do |(name, value)|
          self.singleton_class.send :attr_reader, name
          instance_variable_set(:"@#{name}", value)
        end
      end
    end
  end
end
