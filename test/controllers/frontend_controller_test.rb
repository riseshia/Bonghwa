# frozen_string_literal: true

require "test_helper"

class FrontendControllerTest < ActionDispatch::IntegrationTest
  def setup
    @index_path = Rails.root.join("app", "views", "frontend", "index.html")
    File.open(@index_path, "w") {}
  end

  def teardown
    File.delete(@index_path)
  end

  def test_index
    get root_url
    assert_response :success
  end
end
