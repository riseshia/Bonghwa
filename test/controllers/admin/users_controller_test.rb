# frozen_string_literal: true
require "test_helper"

module Admin
  class UsersControllerTest < ActionController::TestCase
    def setup
      create_app
      @user = create_user(level: 999, login_id: "admin", name: "admin")
      sign_in @user
    end

    def test_index_returns_200
      get :index
      assert_response 200
    end

    def test_edit_returns_200
      user = create_user
      get :edit, params: { id: user.id }
      assert_response 200
    end

    def test_lvup_updates_status
      user = create_user(level: 0)
      put :lvup, params: { id: user.id }

      assert_redirected_to admin_users_path
      assert_equal 1, user.reload.level
      assert_nil RedisWrapper.get("session-#{user.id}")
    end

    def test_update_success_to_update
      user = create_user
      before_password = user.password

      put :update, params: {
        id: user.id, user: {
          password: "new_pass", password_confirmation: "new_pass"
        }
      }

      assert_redirected_to edit_admin_user_path(user)
      refute user.reload.valid_password?(before_password)
    end

    def test_update_fail_to_update
      user = create_user
      before_password = user.password

      put :update, params: {
        id: user.id, user: {
          password: "new_pass", password_confirmation: "wrong_pass"
        }
      }

      assert_response 200
      assert user.reload.valid_password?(before_password)
    end
  end
end
