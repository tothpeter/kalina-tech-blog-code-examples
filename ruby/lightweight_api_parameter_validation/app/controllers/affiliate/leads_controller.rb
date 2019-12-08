# frozen_string_literal: true

class Affiliate::LeadsController < ApplicationController
  before_action :validate_params

  def create
    head 201
  end

  private

  def validate_params
    validator = Affiliate::Lead::ParamsValidation.validator(params)

    return if validator.valid?

    render json: { errors: validator.errors }, status: 422
  end
end
