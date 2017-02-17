# frozen_string_literal: true
require "test_helper"

module Api
  class EntryControllerTest < ActionController::TestCase
    def setup
      create_app
      sign_in user
    end

    def user
      @user ||= create_user(level: 1)
    end

    def test_create_fw
      assert_difference "Firewood.count" do
        post :create, params: {
          firewood: { prev_mt: 0, contents: "firewoods" }
        }, format: :json
      end
      assert_response 200
    end

    def test_create_with_root
      fw = create_firewood

      assert_difference "Firewood.count" do
        post :create, params: {
          firewood: { contents: "firewoods", prev_mt: 0, root_mt_id: fw.id }
        }, format: :json
      end
      assert_response 200
      assert_equal fw.id, Firewood.last.root_mt_id
    end

    def test_create_cmd
      assert_difference "Firewood.count", 2 do
        post :create_cmd, params: {
          firewood: { prev_mt: 0, contents: "/코인" }
        }, format: :json
      end

      assert_response 200
    end

    def test_create_dm
      assert_difference "Firewood.count" do
        post :create_dm, params: {
          firewood: { prev_mt: 0, contents: "!#{user.name} dmdm" }
        }, format: :json
      end

      assert_response 200
    end

    def test_destroy_success
      fw = create_firewood(user: user)
      assert_difference "Firewood.count", -1 do
        delete :destroy, params: { id: fw.id }, format: :json
      end

      assert_response 200
    end

    def test_destroy_fail
      another_user = create_user
      fw = create_firewood(user: another_user)
      assert_no_difference "Firewood.count" do
        delete :destroy, params: { id: fw.id }, format: :json
      end

      assert_response 200
    end

    def test_now
      get :now, params: { type: "1" }, format: :json
      assert_response 200
    end

    def test_mts_has_same_root
      fw = create_firewood(user: user)
      target = create_firewood(user: user, root_mt_id: fw.id)
      create_firewood(user: user) # should not be loaded
      get :mts, params: {
        root_mt_id: fw.id, target_id: target.id
      }, format: :json

      assert_response 200
      assert_equal 1, JSON.parse(response.body)["fws"].size
    end

    def test_pulling
      get :pulling, params: { type: "1" }, format: :json
      assert_response 200
    end

    def test_trace
      get :pulling, params: { type: "2" }, format: :json
      assert_response 200
    end
  end
end
