# frozen_string_literal: true

module AssertHelper
  def assert_response_json_to_be(hash)
    assert_equal JSON.parse(response.body), hash
  end
end

module ActiveSupport
  class TestCase
    include AssertHelper
  end
end
