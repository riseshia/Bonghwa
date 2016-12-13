# frozen_string_literal: true
require "test_helper"

class InfoTest < ActiveSupport::TestCase
  def test_to_hash_for_api_returns_correct_hash
    info = create_info
    expected_hash = {
      id: info.id,
      information: info.infomation
    }
    assert_equal expected_hash, info.to_hash_for_api
  end
end
