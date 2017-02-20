# frozen_string_literal: true
require "test_helper"

class ScripterTest < ActiveSupport::TestCase
  def setup
    @app = apps(:bonghwa)
    @user = users(:asahi)
  end
end
