# frozen_string_literal: true

require './example/invoked_method_reporter'

describe InvokedMethodReporter do
  class TargetClassForInvokedMethodReporter
    def original_impl; end

    def self.original_impl; end

    def unused_method_from_class
      original_impl
    end

    def self.unused_method_from_class
      original_impl
    end
  end

  described_class.bind_to('TargetClassForInvokedMethodReporter#unused_method_from_class')
  described_class.bind_to('TargetClassForInvokedMethodReporter.unused_method_from_class')

  after(:all) do
    Object.send(:remove_const, :TargetClassForInvokedMethodReporter)
  end

  describe '.bind_to' do
    context 'object level' do
      it 'invokes the reporter then the original implementation' do
        target_class_object = TargetClassForInvokedMethodReporter.new

        expect(described_class).to receive(:report).ordered
        expect(target_class_object).to receive(:original_impl).ordered

        target_class_object.unused_method_from_class
      end
    end

    context 'class level' do
      it 'invokes the reporter then the original implementation' do
        expect(described_class).to receive(:report).ordered
        expect(TargetClassForInvokedMethodReporter).to receive(:original_impl).ordered

        TargetClassForInvokedMethodReporter.unused_method_from_class
      end
    end
  end
end
