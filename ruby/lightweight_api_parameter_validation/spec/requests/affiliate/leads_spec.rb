# frozen_string_literal: true

describe 'Create affiliate leads endpoint' do
  context 'when the params are invalid' do
    it 'returns 422 and the errors' do
      post '/affiliate/leads'

      expect(response).to have_http_status(422)

      expected_error_response = {
        errors: {
          customer: {
            name: ["can't be blank"],
            address: {
              postal_code: ["can't be blank"]
            }
          }
        }
      }

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response).to eq(expected_error_response)
    end
  end

  context 'when the params are valid' do
    it 'returns 201' do
      validation_double = double(valid?: true)
      expect(Affiliate::Lead::ParamsValidation).to receive(:validator)
        .and_return(validation_double)

      post '/affiliate/leads'

      expect(response).to have_http_status(201)
    end
  end
end
