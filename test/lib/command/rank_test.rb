# frozen_string_literal: true
require "test_helper"

module Command
  class RankTest < ActiveSupport::TestCase
    def test_reject_args
      regexp = /이 명령어는 추가 인수를 받지 않습니다./
      assert_match regexp, Rank.run(dummy_params("arg1"))
    end

    def test_gets_my_rank
      regexp = /개\)/
      assert_match regexp, Rank.run(dummy_params)
    end

    private

    def dummy_params(args = "")
      build_params("/등수 #{args}")
    end
  end
end
