# frozen_string_literal: true

module InvokedMethodReporter
  def self.bind_to(methods)
    class_level_methods, obj_level_methods = Array(methods).partition { |m| m.include?('.') }

    obj_level_methods.each do |method_definition|
      ObjectLevelBinder.bind_to(method_definition)
    end

    class_level_methods.each do |method_definition|
      ClassLevelBinder.bind_to(method_definition)
    end
  end

  def self.report(method_definition)
  end
end
