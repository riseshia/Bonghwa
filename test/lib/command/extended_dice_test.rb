# frozen_string_literal: true
require "test_helper"

module Command
  class ExtendedDiceTest < ActiveSupport::TestCase
    def dummy_params(command, args = [])
      { script: OpenStruct.new(args: args, command: command) }
    end

    def test_reject_args
      assert_equal "이 명령어는 추가 인수를 받지 않습니다.",
                   ExtendedDice.run(dummy_params("/6d3", ["arg1"]))
    end

    def test_execeed_face_coverage
      regexp = /주사위를 굴리실 수 있습니다./
      assert_match regexp,
                   ExtendedDice.run(dummy_params("/51d3"))
    end

    def test_execeed_number_coverage
      regexp = /주사위를 굴리실 수 있습니다./
      assert_match regexp,
                   ExtendedDice.run(dummy_params("/6d21"))
    end

    def test_dice_well
      regexp = /의 주사위 눈이 나왔습니다./
      assert_match regexp,
                   ExtendedDice.run(dummy_params("/6d3"))
    end
  end
end
