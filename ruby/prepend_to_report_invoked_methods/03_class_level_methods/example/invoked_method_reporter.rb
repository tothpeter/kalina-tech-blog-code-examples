# frozen_string_literal: true

require './example/invoked_method_reporter/binder'
require './example/invoked_method_reporter/class_level_binder'
require './example/invoked_method_reporter/object_level_binder'

module InvokedMethodReporter
  def self.bind_to(method_definition)
    Binder.bind_to(method_definition)
  end

  def self.report(method_definition)
    puts "#{method_definition} was invoked"
  end
end
