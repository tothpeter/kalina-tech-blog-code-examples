# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :affiliate do
    resources :leads, only: :create
  end
end
