# frozen_string_literal: true
require "test_helper"

module Command
  class NicknameTest < ActiveSupport::TestCase
    def dummy_params(user, command, args = [])
      { script: OpenStruct.new(args: args, command: command), user: user }
    end

    def test_reject_empty_args
      params = dummy_params(create_user, "/닉", [])
      regexp = /이 명령어에는 하나의 인수가 필요합니다./
      assert_match regexp, Nickname.run(params)
    end

    def test_reject_many_args
      params = dummy_params(create_user, "/닉", %w(args1 args2))
      regexp = /이 명령어에는 하나의 인수가 필요합니다./
      assert_match regexp, Nickname.run(params)
    end

    def test_reject_same_name
      user = create_user(name: "name")
      params = dummy_params(user, "/닉", ["name"])

      regexp = /변경하실 닉네임이 같습니다./
      assert_match regexp, Nickname.run(params)
    end

    def test_reject_exist_name
      create_user(login_id: "login_id2", name: "new_name")
      user = create_user(name: "name")
      params = dummy_params(user, "/닉", ["new_name"])

      assert_equal "해당하는 닉네임은 이미 존재합니다.", Nickname.run(params)
    end

    def test_rename_user
      user = create_user(name: "name")
      params = dummy_params(user, "/닉", ["new_name"])
      regexp = /로 변경되었습니다./

      assert_match regexp, Nickname.run(params)
      assert_equal "new_name", user.reload.name
    end
  end
end
