# frozen_string_literal: true

require './example/invoked_method_reporter'

describe InvokedMethodReporter do
  module TargetModuleForInvokedMethodReporter
    def original_impl; end

    def unused_method_from_module
      original_impl
    end

    def self.original_impl_in_module; end

    def self.unused_method_in_module
      original_impl_in_module
    end
  end

  class TargetClassInvokedMethodReporter
    def unused_method_from_class
      original_impl
    end

    def self.unused_method_from_class
      original_impl
    end
  end

  described_class.bind_to('TargetModuleForInvokedMethodReporter#unused_method_from_module')
  described_class.bind_to('TargetModuleForInvokedMethodReporter.unused_method_in_module')

  TargetClassInvokedMethodReporter.include TargetModuleForInvokedMethodReporter
  TargetClassInvokedMethodReporter.extend TargetModuleForInvokedMethodReporter

  described_class.bind_to('TargetClassInvokedMethodReporter#unused_method_from_class')
  described_class.bind_to('TargetClassInvokedMethodReporter.unused_method_from_class')

  after(:all) do
    Object.send(:remove_const, :TargetModuleForInvokedMethodReporter)
    Object.send(:remove_const, :TargetClassInvokedMethodReporter)
  end

  describe '.bind_to' do
    context 'when the method is defined in the target module' do
      it 'invokes the reporter then the original implementation' do
        expect(described_class).to receive(:report).ordered
        expect(TargetModuleForInvokedMethodReporter).to receive(:original_impl_in_module).ordered

        TargetModuleForInvokedMethodReporter.unused_method_in_module
      end
    end

    context 'when the method is defined in an included module' do
      context 'object level' do
        it 'invokes the reporter then the original implementation' do
          target_class_object = TargetClassInvokedMethodReporter.new

          expect(described_class).to receive(:report).ordered
          expect(target_class_object).to receive(:original_impl).ordered

          target_class_object.unused_method_from_module
        end
      end

      context 'class level' do
        it 'invokes the reporter then the original implementation' do
          expect(described_class).to receive(:report).ordered
          expect(TargetClassInvokedMethodReporter).to receive(:original_impl).ordered

          TargetClassInvokedMethodReporter.unused_method_from_module
        end
      end
    end

    context 'when the method is defined the class itself' do
      context 'object level' do
        it 'invokes the reporter then the original implementation' do
          target_class_object = TargetClassInvokedMethodReporter.new

          expect(described_class).to receive(:report).ordered
          expect(target_class_object).to receive(:original_impl).ordered

          target_class_object.unused_method_from_class
        end
      end

      context 'class level' do
        it 'invokes the reporter then the original implementation' do
          expect(described_class).to receive(:report).ordered
          expect(TargetClassInvokedMethodReporter).to receive(:original_impl).ordered

          TargetClassInvokedMethodReporter.unused_method_from_class
        end
      end
    end
  end
end
