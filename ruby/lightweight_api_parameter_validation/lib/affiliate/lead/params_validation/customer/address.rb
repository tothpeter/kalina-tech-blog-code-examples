# frozen_string_literal: true

module Affiliate
  module Lead
    module ParamsValidation
      class Customer
        class Address < Base
          validates_presence_of :postal_code
        end
      end
    end
  end
end
