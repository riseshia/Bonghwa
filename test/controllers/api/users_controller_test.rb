# frozen_string_literal: true

require "test_helper"

module Api
  class UsersControllerTest < ActionController::TestCase
    def setup
      sign_in_via_api users(:asahi)
    end

    def test_index
      get :index, format: :json

      expected = { "users" => [] }

      assert_response :ok
      assert_response_json_to_be expected
    end
  end
end
