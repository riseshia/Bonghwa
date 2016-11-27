# frozen_string_literal: true
require "test_helper"

class AppTest < ActiveSupport::TestCase
  validate_presence_of(:app_name)

  def app
    @app ||= App.new
  end
end
