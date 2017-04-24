# frozen_string_literal: true
require "test_helper"

module Command
  class RemoveInfoTest < ActiveSupport::TestCase
    def test_no_permission
      params = dummy_params("1", normal_user)
      assert_equal "권한이 없습니다.", RemoveInfo.run(params)
    end

    def test_no_info_id
      params = dummy_params("", admin)
      assert_equal "삭제할 공지의 id를 주셔야합니다.", RemoveInfo.run(params)
    end

    def test_rejects_many_args
      params = dummy_params("1 2", admin)
      assert_equal "인수가 너무 많습니다. 삭제할 공지의 번호만을 주세요.",
                   RemoveInfo.run(params)
    end

    def test_rejects_not_exist_info
      params = dummy_params("#{Info.count + 1}", admin)
      assert_equal "삭제할 공지사항이 없습니다.", RemoveInfo.run(params)
    end

    def test_success
      params = dummy_params("#{Info.count}", admin)

      assert_difference "Info.count", -1 do
        assert_equal "삭제 완료되었습니다.", RemoveInfo.run(params)
      end
    end

    private

    def normal_user
      users(:asahi)
    end

    def admin
      users(:luna)
    end

    def dummy_params(args = "", user)
      build_params("/주사위 #{args}", user)
    end
  end
end
