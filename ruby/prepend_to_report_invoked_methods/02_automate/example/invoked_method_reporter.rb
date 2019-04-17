# frozen_string_literal: true

module InvokedMethodReporter
  def self.report(method_definition)
    puts "#{method_definition} was invoked"
  end
end
