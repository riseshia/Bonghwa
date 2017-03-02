# frozen_string_literal: true
require "test_helper"

module Users
  class RegistrationsControllerTest < ActionController::TestCase
    def setup
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    def test_new_returns_200
      get :new
      assert_response 200
    end

    def test_create_returns_302
      konochiyo = {
        login_id: "konochiyo",
        name: "Konochiyo",
        password: "password",
        password_confirmation: "password"
      }

      assert_difference "User.count" do
        post :create, params: { user: konochiyo }
      end
      assert_response 302
    end
  end
end

