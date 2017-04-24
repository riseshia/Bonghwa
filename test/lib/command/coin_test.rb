# frozen_string_literal: true
require "test_helper"

module Command
  class CoinTest < ActiveSupport::TestCase
    def dummy_params(args = "")
      build_params("/코인 #{args}")
    end

    def test_coin_toss
      regexp = /이 나왔습니다./
      assert_match regexp, Coin.run(dummy_params)
    end

    def test_coin_toss_fail
      actual = Coin.run(dummy_params("param"))
      assert_equal "'/코인'은 인수를 받지 않습니다.", actual
    end
  end
end
