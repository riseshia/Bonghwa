# frozen_string_literal: true

require "test_helper"

class ViewControllerTest < ActionController::TestCase
  def setup
    sign_in user
  end

  def test_wait
    get :wait
    assert_response 200
  end

  private

  def user
    @user ||= users(:gnunu)
  end
end
