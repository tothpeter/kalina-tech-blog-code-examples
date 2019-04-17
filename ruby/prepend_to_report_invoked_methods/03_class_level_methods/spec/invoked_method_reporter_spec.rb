# frozen_string_literal: true

require './invoked_method_reporter'
require './invoked_method_reporter/binder'
require './invoked_method_reporter/class_level_binder'
require './invoked_method_reporter/object_level_binder'

describe InvokedMethodReporter do
  class TargetClass
    def original_impl; end
    def self.original_impl; end

    def unused_method_from_class
      original_impl
    end

    def self.unused_method_from_class
      original_impl
    end
  end

  described_class.bind_to('TargetClass#unused_method_from_class')
  described_class.bind_to('TargetClass.unused_method_from_class')

  after(:all) do
    Object.send(:remove_const, :TargetClass)
  end

  describe '.bind_to' do
    context 'when the method is defined the class itself' do
      context 'object level method' do
        it 'invokes the reporter then the original implementation' do
          target_class_object = TargetClass.new

          expect(described_class).to receive(:report).ordered.and_call_original
          expect(target_class_object).to receive(:original_impl).ordered

          target_class_object.unused_method_from_class
        end
      end

      context 'class level method' do
        it 'invokes the reporter then the original implementation' do
          expect(described_class).to receive(:report).ordered.and_call_original
          expect(TargetClass).to receive(:original_impl).ordered

          TargetClass.unused_method_from_class
        end
      end
    end
  end
end
