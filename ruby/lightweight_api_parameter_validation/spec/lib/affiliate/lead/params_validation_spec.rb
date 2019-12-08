# frozen_string_literal: true

describe Affiliate::Lead::ParamsValidation do
  context 'no data' do
    it 'returns all the errors' do
      validator = described_class.validator({})

      validator.validate

      expected_errors = {
        customer: {
          name: ["can't be blank"],
          address: {
            postal_code: ["can't be blank"]
          }
        }
      }

      expect(validator.errors.to_hash).to eq(expected_errors)
    end
  end

  context 'minimum valid data' do
    it 'passes the validation' do
      params = {
        customer: {
          name: 'Name',
          address: {
            postal_code: '1234'
          }
        }
      }

      validator = described_class.validator(params)

      expect(validator.valid?).to eq(true)
    end
  end
end
