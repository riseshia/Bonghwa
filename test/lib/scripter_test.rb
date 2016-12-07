# frozen_string_literal: true
require "test_helper"

class ScripterTest < ActiveSupport::TestCase
  def setup
    @app = create_app
    @user = create_user
  end
end
