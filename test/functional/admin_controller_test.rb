require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get new_app" do
    get :new_app
    assert_response :success
  end

  test "should get create_app" do
    get :create_app
    assert_response :success
  end

end
