# frozen_string_literal: true

module ActionController
  class TestCase
    include Devise::Test::ControllerHelpers

    def sign_in_via_api(model)
      model.generate_token
      @request.headers["X-User-Identifier"] = model.login_id
      @request.headers["X-User-Token"] = model.authentication_token
    end
  end
end
