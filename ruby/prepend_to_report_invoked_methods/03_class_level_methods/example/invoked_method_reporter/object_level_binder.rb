# frozen_string_literal: true

module InvokedMethodReporter
  class ObjectLevelBinder < Binder
    SEPARATOR = '#'

    private

    def target_const
      Object.const_get(namespace)
    end
  end
end
