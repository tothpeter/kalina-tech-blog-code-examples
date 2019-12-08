# frozen_string_literal: true

module Affiliate
  module Lead
    module ParamsValidation
      class Customer < Base
        validates_presence_of :name

        validate :validate_address

        private

        def validate_address
          address_validator = Address.new(data[:address])

          return if address_validator.valid?

          add_nested_errors_for(:address, address_validator)
        end
      end
    end
  end
end
