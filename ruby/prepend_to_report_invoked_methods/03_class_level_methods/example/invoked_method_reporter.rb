# frozen_string_literal: true

module InvokedMethodReporter
  def self.bind_to(method_definition)
    if method_definition.include?('.')
      ClassLevelBinder.bind_to(method_definition)
    else
      ObjectLevelBinder.bind_to(method_definition)
    end
  end

  def self.report(method_definition)
    puts "#{method_definition} was invoked"
  end
end
