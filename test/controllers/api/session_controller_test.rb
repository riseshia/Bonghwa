# frozen_string_literal: true

require "test_helper"

module Api
  class SessionControllerTest < ActionController::TestCase
    def test_create_session_correctly
      expected_token = "some_token"

      SimpleTokenAuthentication::TokenGenerator.instance.stub(
        :generate_token, expected_token
      ) do
        post :create, params: { login_id: user.login_id,
                                password: correct_password },
                      format: :json

        assert_response :ok
        assert_response_json_to_be "status"=>"success",
                                   "token" => expected_token
      end
    end

    def test_create_session_fail
      post :create, params: { login_id: user.login_id,
                              password: "wrong_password" }

      assert_response :ok
      assert_response_json_to_be "status"=>"fail",
                                 "message" => "fail to create session"
    end

    def test_destroy_session_correctly
      sign_in_via_api user
      old_token = user.authentication_token

      delete :destroy

      assert_response :ok
      assert_response_json_to_be "status"=>"success", "message" => "good bye"
      assert_not_equal user.reload.authentication_token, old_token
    end

    def test_destroy_without_token
      delete :destroy
      assert_response :redirect
    end

    private

    def user
      @user ||=
        users(:asahi).tap { |obj| obj.update(password: correct_password) }
    end

    def correct_password
      "lunalove"
    end
  end
end
