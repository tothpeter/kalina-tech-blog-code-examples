# frozen_string_literal: true

require './example/lib/invoked_method_reporter'

describe InvokedMethodReporter do
  module TargetModule
    def original_impl; end

    def unused_method_from_module
      original_impl
    end

    def self.original_impl_in_module; end

    def self.unused_method_in_module
      original_impl_in_module
    end
  end

  class TargetClass
    def unused_method_from_class
      original_impl
    end

    def self.unused_method_from_class
      original_impl
    end
  end

  described_class.bind_to('TargetModule#unused_method_from_module')
  described_class.bind_to('TargetModule.unused_method_in_module')

  TargetClass.include TargetModule
  TargetClass.extend TargetModule

  described_class.bind_to('TargetClass#unused_method_from_class')
  described_class.bind_to('TargetClass.unused_method_from_class')

  after(:all) do
    Object.send(:remove_const, :TargetModule)
    Object.send(:remove_const, :TargetClass)
  end

  describe '.config' do
    it 'returns an InvokedMethodReporter::Config object' do
      expect(described_class.config).to be_kind_of(InvokedMethodReporter::Config)
    end
  end

  describe '.bind_to' do
    context 'when the method is defined in the target module' do
      it 'invokes the reporter then the original implementation' do
        expect(described_class).to receive(:report).ordered.and_call_original
        expect(TargetModule).to receive(:original_impl_in_module).ordered

        TargetModule.unused_method_in_module
      end
    end

    context 'when the method is defined in an included module' do
      context 'object level' do
        it 'invokes the reporter then the original implementation' do
          target_class_object = TargetClass.new

          expect(described_class).to receive(:report).ordered.and_call_original
          expect(target_class_object).to receive(:original_impl).ordered

          target_class_object.unused_method_from_module
        end
      end

      context 'class level' do
        it 'invokes the reporter then the original implementation' do
          expect(described_class).to receive(:report).ordered.and_call_original
          expect(TargetClass).to receive(:original_impl).ordered

          TargetClass.unused_method_from_module
        end
      end
    end

    context 'when the method is defined the class itself' do
      context 'object level' do
        it 'invokes the reporter then the original implementation' do
          target_class_object = TargetClass.new

          expect(described_class).to receive(:report).ordered.and_call_original
          expect(target_class_object).to receive(:original_impl).ordered

          target_class_object.unused_method_from_class
        end
      end

      context 'class level' do
        it 'invokes the reporter then the original implementation' do
          expect(described_class).to receive(:report).ordered.and_call_original
          expect(TargetClass).to receive(:original_impl).ordered

          TargetClass.unused_method_from_class
        end
      end
    end
  end

  describe '.report' do
    context 'when the method is defined in a module and added to the class' do
      it 'invokes Rollbar with the right params' do
        expected_message = '[InvokedMethodReporter] TargetModule#unused_method_from_module was invoked'

        expect(Rollbar).to receive(:info).with(expected_message, anything).exactly(2).times

        TargetClass.unused_method_from_module
        TargetClass.new.unused_method_from_module
      end
    end

    context 'when the method is defined by the class itself' do
      it 'invokes Rollbar with the right params' do
        expected_message1 = '[InvokedMethodReporter] TargetClass#unused_method_from_class was invoked'
        expected_message2 = '[InvokedMethodReporter] TargetClass.unused_method_from_class was invoked'

        expect(Rollbar).to receive(:info).with(expected_message1, anything)
        expect(Rollbar).to receive(:info).with(expected_message2, anything)

        TargetClass.unused_method_from_class
        TargetClass.new.unused_method_from_class
      end
    end
  end
end
