# frozen_string_literal: true
require "test_helper"

module Admin
  class AppControllerTest < ActionController::TestCase
    def setup
      sign_in users(:luna)
    end

    def test_edit_returns_200
      get :edit
      assert_response 200
    end

    def test_update_success_to_update
      expected_name = "another_name"
      patch :update, params: { app: { app_name: expected_name } }
      assert expected_name, App.first.app_name
      assert_redirected_to admin_app_path
    end

    def test_update_fail_to_update
      invalid_name = ""
      patch :update, params: { app: { app_name: invalid_name } }
      assert_response 200
      refute_equal "", App.first.app_name
    end
  end
end
