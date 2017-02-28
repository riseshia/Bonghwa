# frozen_string_literal: true
require "test_helper"

module Users
  class SessionsControllerTest < ActionController::TestCase
    def setup
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    def test_create_refresh_timestamp
      t = Time.zone.now - 1.second
      asahi = users(:asahi)
      password = "password"
      asahi.update(password: "password")

      post :create, params: {
        user: { login_id: asahi.login_id, password: password, remember_me: 0 }
      }
      assert_response 302
      assert asahi.reload.recent_login >= t
    end

    def test_destroy_session
      sign_in users(:asahi)

      delete :destroy
      assert_response 302
    end
  end
end
