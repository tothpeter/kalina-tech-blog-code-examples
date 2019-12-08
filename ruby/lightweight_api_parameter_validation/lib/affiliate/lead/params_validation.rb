# frozen_string_literal: true

module Affiliate
  module Lead
    module ParamsValidation
      def self.validator(params)
        Main.new(params)
      end
    end
  end
end
