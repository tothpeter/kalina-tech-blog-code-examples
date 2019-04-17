# frozen_string_literal: true

require 'yaml'

module InvokedMethodReporter
  class Config
    def initialize
      @config = YAML.load_file('example/config/invoked_method_reporter.yml')
    end

    def methods_to_report
      @config['methods_to_report']
    end
  end
end
