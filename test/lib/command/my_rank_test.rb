# frozen_string_literal: true
require "test_helper"

module Command
  class MyRankTest < ActiveSupport::TestCase
    def dummy_params(user, command, args = [])
      { script: OpenStruct.new(args: args, command: command), user: user }
    end

    def test_reject_args
      params = dummy_params(build_user, "/내등수", ["arg1"])
      regexp = /이 명령어는 추가 인수를 받지 않습니다./
      assert_match regexp,
                   MyRank.run(params)
    end

    def test_gets_my_rank
      params = dummy_params(build_user, "/내등수")
      regexp = /님이 던지신 장작은/
      assert_match regexp, MyRank.run(params)
    end
  end
end
