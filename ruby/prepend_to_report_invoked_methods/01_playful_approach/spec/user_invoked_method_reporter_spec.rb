# frozen_string_literal: true

require './user'
require './user_invoked_method_reporter'

describe UserInvokedMethodReporter do
  it 'invokes the reporter then the original impl' do
    expect(STDOUT).to receive(:puts).with('User#unused_method_from_class was invoked').ordered
    expect(STDOUT).to receive(:puts).with('Original impl with: Param1').ordered

    User.new.unused_method_from_class('Param1')
  end
end
