# frozen_string_literal: true
require "test_helper"

class ViewControllerTest < ActionController::TestCase
  def setup
    create_app
    sign_in user
  end

  def user
    @user ||= create_user(level: 1)
  end

  def test_timeline
    get :timeline
    assert_response 200
  end
end
