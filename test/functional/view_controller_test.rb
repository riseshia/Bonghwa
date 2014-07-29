require 'test_helper'

class ViewControllerTest < ActionController::TestCase
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

  test "should get option" do
    get :option
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

end
