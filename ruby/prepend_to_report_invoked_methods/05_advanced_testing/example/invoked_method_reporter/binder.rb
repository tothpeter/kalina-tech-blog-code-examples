# frozen_string_literal: true

module InvokedMethodReporter
  class Binder
    attr_reader :namespace, :method_name, :method_definition

    def self.bind_to(method_definition)
      if method_definition.include?('.')
        ClassLevelBinder.new(method_definition).bind
      else
        ObjectLevelBinder.new(method_definition).bind
      end
    end

    def initialize(method_definition)
      @method_definition       = method_definition
      @namespace, @method_name = method_definition.split(self.class::SEPARATOR)
    end

    def bind
      target_const.prepend(module_to_prepend)
    end

    private

    def module_to_prepend
      local_method_name       = method_name
      local_method_definition = method_definition

      Module.new do
        define_method(local_method_name) do |*args|
          InvokedMethodReporter.report(local_method_definition)
          super(*args)
        end
      end
    end
  end
end
