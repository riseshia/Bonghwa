# frozen_string_literal: true
require "test_helper"

module Command
  class DisabledTest < ActiveSupport::TestCase
    def test_run
      actual = Disabled.run({})
      expected = "명령 기능이 비활성화되어 있습니다. 관리자에게 문의하세요."
      assert_equal expected, actual
    end
  end
end
