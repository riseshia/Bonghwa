# frozen_string_literal: true

require "test_helper"

module Api
  class InfosControllerTest < ActionController::TestCase
    def setup
      sign_in_via_api users(:asahi)
    end

    def test_index
      get :index, format: :json

      expected = {
        "infos" => [{ "id" => 691_034_298, "information" => "夏休みです" }]
      }

      assert_response :ok
      assert_response_json_to_be expected
    end
  end
end
