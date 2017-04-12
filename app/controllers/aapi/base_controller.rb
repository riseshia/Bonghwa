# frozen_string_literal: true

module Aapi
  # Aapi::BaseController
  class BaseController < ActionController::Base
    acts_as_token_authentication_handler_for User
  end
end
