# frozen_string_literal: true

require './example/user'
require './example/invoked_method_reporter'
require './example/invoked_method_reporter/binder'

describe InvokedMethodReporter::Binder do
  describe '.bind' do
    it 'invokes the reporter then the original impl' do
      InvokedMethodReporter::Binder.bind('User#unused_method_from_class')

      expect(STDOUT).to receive(:puts).with('User#unused_method_from_class was invoked').ordered
      expect(STDOUT).to receive(:puts).with('Original impl with: Param1').ordered

      User.new.unused_method_from_class('Param1')
    end
  end
end
