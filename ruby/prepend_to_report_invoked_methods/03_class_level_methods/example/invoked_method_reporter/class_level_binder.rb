# frozen_string_literal: true

module InvokedMethodReporter
  class ClassLevelBinder < Binder
    SEPARATOR = '.'

    private

    def target_const
      Object.const_get(namespace).singleton_class
    end
  end
end
