# frozen_string_literal: true
require "test_helper"

module Command
  class NotFoundTest < ActiveSupport::TestCase
    def dummy_params(command)
      { script: OpenStruct.new(command: command) }
    end

    def test_run
      actual = NotFound.run(dummy_params("/not_cmd"))
      assert_equal "명령어 '/not_cmd'를 찾을 수 없습니다.", actual
    end
  end
end
