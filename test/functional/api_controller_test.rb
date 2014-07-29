require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get new_dm" do
    get :new_dm
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new_cmd" do
    get :new_cmd
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get now" do
    get :now
    assert_response :success
  end

  test "should get mt" do
    get :mt
    assert_response :success
  end

  test "should get me" do
    get :me
    assert_response :success
  end

  test "should get pulling" do
    get :pulling
    assert_response :success
  end

end
