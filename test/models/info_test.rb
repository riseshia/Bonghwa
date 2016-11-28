# frozen_string_literal: true
require "test_helper"

def build_info(params = {})
  default_params = {
    infomation: "Information",
    created_at: Time.zone.now
  }
  Info.new(default_params.merge(params))
end

def create_info(params = {})
  build_info(params).tap(&:save)
end

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
