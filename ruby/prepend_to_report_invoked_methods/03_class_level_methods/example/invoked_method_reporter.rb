# frozen_string_literal: true

module InvokedMethodReporter
  def self.bind_to(method_definition)
    Binder.bind_to(method_definition)
  end

  def self.report(method_definition)
    puts "#{method_definition} was invoked"
  end
end
