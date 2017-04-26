# frozen_string_literal: true

module Api
  # Api::BaseController
  class BaseController < ActionController::Base
    acts_as_token_authentication_handler_for User
    before_action :set_raven_context

    private

    def set_raven_context
      Raven.user_context(id: current_user&.id) # or anything else in session
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
  end
end
