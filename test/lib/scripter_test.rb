# frozen_string_literal: true
require "test_helper"

module Command
  module SomeCmd
  end
end

class ScripterTest < ActiveSupport::TestCase
  def setup
    @app = apps(:bonghwa)
    @user = users(:asahi)
  end

  def test_cmd_find_returns_disabled
    @app.use_script = 0
    assert_equal Command::Disabled, Scripter.cmd_find("some input", @app)
  end

  def test_cmd_find_returns_some_command
    Scripter.register "/cmd", Command::SomeCmd
    assert_equal Command::SomeCmd, Scripter.cmd_find("/cmd", @app)
  end

  def test_cmd_find_returns_matched_command
    Scripter.register %r{\/regex}, Command::SomeCmd
    assert_equal Command::SomeCmd, Scripter.cmd_find("/regex", @app)
  end

  def test_cmd_find_returns_not_found
    assert_equal Command::NotFound, Scripter.cmd_find("/not_exist", @app)
  end
end
