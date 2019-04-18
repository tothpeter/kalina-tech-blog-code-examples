# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'active_support/backtrace_cleaner'

require './example/lib/rollbar'
require './example/lib/invoked_method_reporter/config'
require './example/lib/invoked_method_reporter/binder'
require './example/lib/invoked_method_reporter/class_level_binder'
require './example/lib/invoked_method_reporter/object_level_binder'

module InvokedMethodReporter
  def self.config
    @config ||= Config.new
  end

  def self.setup
    methods_to_report = InvokedMethodReporter.config.methods_to_report
    bind_to(methods_to_report)
  end

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
    message = "[InvokedMethodReporter] #{method_definition} was invoked"

    report_params = {
      sender: sender_trace
    }

    Rollbar.info(message, report_params)
  rescue StandardError => e
    Rollbar.error('Error in InvokedMethodReporter.report', e)
  end

  def self.sender_trace
    backtrace_cleaner = ActiveSupport::BacktraceCleaner.new

    filters = [
      'invoked_method_reporter/binder.rb',
      'invoked_method_reporter.rb',
      'gems'
    ]

    backtrace_cleaner.add_silencer do |line|
      filters.any? { |filter| line.include?(filter) }
    end

    backtrace_cleaner.clean(caller).first
  end
end
