# frozen_string_literal: true

module InvokedMethodReporter
  class Binder
    attr_reader :namespace, :method_name, :method_definition

    def self.bind_to(method_definition)
      new(method_definition).bind
    end

    def initialize(method_definition)
      @method_definition       = method_definition
      @namespace, @method_name = method_definition.split('#')
    end

    def bind
      target_const.prepend(module_to_prepend)
    end

    private

    def target_const
      Object.const_get(namespace)
    end

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
