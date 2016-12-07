# frozen_string_literal: true
require "test_helper"

module Command
  class RankTest < ActiveSupport::TestCase
    def dummy_params(args = [])
      { script: OpenStruct.new(args: args) }
    end

    def test_reject_args
      regexp = /이 명령어는 추가 인수를 받지 않습니다./
      assert_match regexp, Rank.run(dummy_params(["arg1"]))
    end

    def test_gets_my_rank
      create_firewood(user: create_user)
      regexp = /개\)/
      assert_match regexp, Rank.run(dummy_params)
    end
  end
end
