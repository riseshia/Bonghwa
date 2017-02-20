# frozen_string_literal: true
require "test_helper"

module Command
  class NicknameTest < ActiveSupport::TestCase
    def test_reject_empty_args
      params = dummy_params(normal_user, "/닉", [])
      regexp = /이 명령어에는 하나의 인수가 필요합니다./
      assert_match regexp, Nickname.run(params)
    end

    def test_reject_many_args
      params = dummy_params(normal_user, "/닉", %w(args1 args2))
      regexp = /이 명령어에는 하나의 인수가 필요합니다./
      assert_match regexp, Nickname.run(params)
    end

    def test_reject_same_name
      params = dummy_params(normal_user, "/닉", [normal_user.name])

      regexp = /변경하실 닉네임이 같습니다./
      assert_match regexp, Nickname.run(params)
    end

    def test_reject_exist_name
      luna = users(:luna)
      params = dummy_params(luna, "/닉", [normal_user.name])

      assert_equal "해당하는 닉네임은 이미 존재합니다.", Nickname.run(params)
    end

    def test_rename_user
      expected = "Ryusei"
      params = dummy_params(normal_user, "/닉", [expected])
      regexp = /로 변경되었습니다./

      assert_match regexp, Nickname.run(params)
      assert_equal expected, normal_user.reload.name
    end

    private

    def dummy_params(user, command, args = [])
      { script: OpenStruct.new(args: args, command: command), user: user }
    end

    def normal_user
      users(:asahi)
    end
  end
end
