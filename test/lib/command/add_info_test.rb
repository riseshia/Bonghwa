# frozen_string_literal: true
require "test_helper"

module Command
  class AddInfoTest < ActiveSupport::TestCase
    def dummy_params(arg, user)
      { script: OpenStruct.new(arg: arg), user: user }
    end

    def test_no_permission
      params = dummy_params("some information", build_user(level: 1))
      assert_equal "권한이 없습니다.", AddInfo.run(params)
    end

    def test_no_information
      params = dummy_params("", build_user(level: 999))
      assert_equal "내용을 입력해주세요.", AddInfo.run(params)
    end

    def test_success
      params = dummy_params("some information", build_user(level: 999))

      assert_difference "Info.count" do
        assert_equal "공지가 등록되었습니다.", AddInfo.run(params)
      end
    end
  end
end
