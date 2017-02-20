# frozen_string_literal: true
require "test_helper"

class UsersControllerTest < ActionController::TestCase
  def setup
    sign_in user
  end

  def test_show_redirected_to_root
    get :show, params: { id: user.id + 1 }
    assert_redirected_to root_path
  end

  def test_show_returns_200
    get :show, params: { id: user.id }
    assert_response 200
  end

  def test_edit_redirected_to_root
    get :edit, params: { id: user.id + 1 }
    assert_redirected_to root_path
  end

  def test_edit_returns_200
    get :edit, params: { id: user.id }
    assert_response 200
  end

  def test_update_success_to_update
    before_password = user.password

    put :update, params: {
      id: user.id, user: {
        password: "new_pass", password_confirmation: "new_pass"
      }
    }

    assert_redirected_to edit_user_path(user)
    refute user.reload.valid_password?(before_password)
  end

  def test_update_fail_to_update
    before_password = user.password
    new_password = "new_pass"

    put :update, params: {
      id: user.id, user: {
        password: new_password, password_confirmation: "wrong_pass"
      }
    }

    assert_response 200
    refute user.reload.valid_password?(new_password)
  end

  private

  def user
    @user ||= users(:asahi)
  end
end
