# frozen_string_literal: true

module Affiliate
  module Lead
    module ParamsValidation
      class Main < Base
        validate :validate_customer

        private

        def validate_customer
          customer_validator = Customer.new(data[:customer])

          return if customer_validator.valid?

          add_nested_errors_for(:customer, customer_validator)
        end
      end
    end
  end
end
