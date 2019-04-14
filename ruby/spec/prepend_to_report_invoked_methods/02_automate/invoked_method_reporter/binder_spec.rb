# frozen_string_literal: true

# invoked_method_reporter/binder_spec.rb

require 'prepend_to_report_invoked_methods/02_automate/user'
require 'prepend_to_report_invoked_methods/02_automate/invoked_method_reporter'
require 'prepend_to_report_invoked_methods/02_automate/invoked_method_reporter/binder'

describe InvokedMethodReporter::Binder do
  describe '.bind' do
    it 'invokes the reporter then the original impl' do
      InvokedMethodReporter::Binder.bind('User#unused_method1')

      expect(STDOUT).to receive(:puts).with('User#unused_method1 was invoked').ordered
      expect(STDOUT).to receive(:puts).with('Original impl with: Param1').ordered

      User.new.unused_method1('Param1')
    end
  end
end
