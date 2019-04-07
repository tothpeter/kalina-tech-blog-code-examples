# frozen_string_literal: true

# user_invoked_method_reporter_spec.rb

require 'prepend_to_report_invoked_methods/01_playful_approach/user'
require 'prepend_to_report_invoked_methods/01_playful_approach/user_invoked_method_reporter'

describe UserInvokedMethodReporter do
  it 'invokes the reporter then the original impl' do
    expect(STDOUT).to receive(:puts).with('User#unused_method1 was invoked').ordered
    expect(STDOUT).to receive(:puts).with('Original impl with: Param1').ordered

    User.new.unused_method1('Param1')
  end
end
