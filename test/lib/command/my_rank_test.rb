# frozen_string_literal: true
require "test_helper"

module Command
  class MyRankTest < ActiveSupport::TestCase
    def test_reject_args
      params = build_params("/내등수 arg1", user)
      regexp = /이 명령어는 추가 인수를 받지 않습니다./
      assert_match regexp,
                   MyRank.run(params)
    end

    def test_gets_my_rank
      params = build_params("/내등수", user)
      regexp = /님이 던지신 장작은/
      assert_match regexp, MyRank.run(params)
    end

    private

    def user
      users(:asahi)
    end
  end
end
