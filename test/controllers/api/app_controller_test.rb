# frozen_string_literal: true

require "test_helper"

module Api
  class AppControllerTest < ActionController::TestCase
    def setup
      sign_in_via_api users(:asahi)
    end

    def test_show
      get :show, params: { type: 1 },  format: :json

      assert_response :ok
      assert_response_json_has_keys %w(users infos fws app user)
    end
  end
end
