# frozen_string_literal: true
require "test_helper"

module Admin
  class UsersControllerTest < ActionController::TestCase
    def setup
      sign_in users(:luna)
    end

    def test_index_returns_200
      get :index
      assert_response 200
    end

    def test_edit_returns_200
      asahi = users(:asahi)
      get :edit, params: { id: asahi.id }
      assert_response 200
    end

    def test_lvup_updates_status
      gnunu = users(:gnunu)
      put :lvup, params: { id: gnunu.id }

      assert_redirected_to admin_users_path
      assert_equal 1, gnunu.reload.level
      assert_nil RedisWrapper.get("session-#{gnunu.id}")
    end

    def test_update_success_to_update
      asahi = users(:asahi)
      new_password = "new_pass"

      put :update, params: {
        id: asahi.id, user: {
          password: new_password, password_confirmation: new_password
        }
      }

      assert_redirected_to edit_admin_user_path(asahi)
      assert asahi.reload.valid_password?(new_password)
    end

    def test_update_fail_to_update
      asahi = users(:asahi)
      new_password = "new_pass"

      put :update, params: {
        id: asahi.id, user: {
          password: new_password, password_confirmation: "wrong_pass"
        }
      }

      assert_response 200
      refute asahi.reload.valid_password?(new_password)
    end
  end
end
