# frozen_string_literal: true
require "test_helper"

class ScriptTest < ActiveSupport::TestCase
  def test_arg_returns_empty_string
    script = setup_script("some_text_with_no_space")
    assert_equal "", script.arg
  end

  def test_arg_returns_joined_args
    script = setup_script("some args1 args2")
    assert_equal "args1 args2", script.arg
  end

  def test_returns_correct_parsed_args
    script = setup_script("command args1 args2")
    assert_equal %w(args1 args2), script.args
  end

  def test_returns_correct_parsed_command
    script = setup_script("command args1 args2")
    assert_equal "command", script.command
  end

  def test_ignore_tags_included
    script = setup_script("command args1 args2 #tag")
    assert_equal %w(args1 args2), script.args
    assert_equal "args1 args2", script.arg
  end

  private

  def setup_script(contents)
    Script.new(Firewood.new(contents: contents))
  end
end
