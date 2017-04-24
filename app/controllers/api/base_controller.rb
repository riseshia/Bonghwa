# frozen_string_literal: true

module Api
  # Api::BaseController
  class BaseController < ActionController::Base
    acts_as_token_authentication_handler_for User
  end
end
