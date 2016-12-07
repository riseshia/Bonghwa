# frozen_string_literal: true
require "test_helper"

module Command
  class SimpleDiceTest < ActiveSupport::TestCase
    def dummy_params(args = [])
      { script: OpenStruct.new(args: args) }
    end

    def test_rejects_many_args
      assert_equal "명령어는 '/주사위 {면수:생략시 6}'입니다.",
                   SimpleDice.run(dummy_params(%w(1 2)))
    end

    def test_rejects_invalid_args
      %w(0 1000 string).each do |args|
        regexp = /인수 지정이 잘못되었습니다./
        assert_match regexp, SimpleDice.run(dummy_params([args]))
      end
    end

    def test_success_with_no_params
      regexp = /나왔습니다./
      assert_match regexp, SimpleDice.run(dummy_params)
    end

    def test_success_with_params
      regexp = /나왔습니다./
      assert_match regexp, SimpleDice.run(dummy_params(["30"]))
    end
  end
end
