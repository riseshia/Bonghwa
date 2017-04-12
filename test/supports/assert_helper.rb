# frozen_string_literal: true

module AssertHelper
  def assert_response_json_to_be(hash)
    assert_equal res_json, hash
  end

  def assert_response_json_has_keys(keys)
    assert_equal res_json.keys, keys
  end

  def res_json
    JSON.parse(response.body)
  end
end

module ActiveSupport
  class TestCase
    include AssertHelper
  end
end
