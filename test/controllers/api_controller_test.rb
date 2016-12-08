# frozen_string_literal: true
require "test_helper"

class ApiControllerTest < ActionController::TestCase
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
        firewood: {
          prev_mt: 0, contents: "firewoods",
        },
        attached_file: nil,
        adult_check: nil
      }
    end

    assert_response 200
  end

  def test_create_cmd
    assert_difference "Firewood.count", 2 do
      post :create_cmd, params: {
        firewood: {
          prev_mt: 0, contents: "/코인",
        },
        attached_file: nil,
        adult_check: nil
      }
    end

    assert_response 200
  end

  def test_create_dm
    assert_difference "Firewood.count" do
      post :create_dm, params: {
        firewood: {
          prev_mt: 0, contents: "!#{user.name} dmdm",
        },
        attached_file: nil,
        adult_check: nil
      }
    end

    assert_response 200
  end

  def test_destroy_success
    fw = create_firewood(user: user)
    assert_difference "Firewood.count", -1 do
      delete :destroy, params: { id: fw.id }
    end

    assert_response 200
  end

  def test_destroy_fail
    another_user = create_user
    fw = create_firewood(user: another_user)
    assert_no_difference "Firewood.count" do
      delete :destroy, params: { id: fw.id }
    end

    assert_response 200
  end

  def test_now
    get :now, params: { type: "1" }
    assert_response 200
  end

  def test_mts
    fw = create_firewood(user: user)
    get :mts, params: { prev_mt: fw.id }
    assert_response 200
  end

  def test_pulling
    get :pulling, params: { type: "1" }
    assert_response 200
  end

  def test_trace
    get :pulling, params: { type: "1" }
    assert_response 200
  end
end
