# frozen_string_literal: true
ENV["RAILS_ENV"] = "test"
require "simplecov"
require "coveralls"
SimpleCov.start "rails" do
  add_filter "/test/"
  add_filter "/config/"
end
Coveralls.wear!

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/pride"

Dir[Rails.root.join("test", "supports", "**", "*.rb")].each { |f| require f }

RedisWrapper.instance = MockRedis.new

module ActiveSupport
  class TestCase
    fixtures :all
    self.use_transactional_tests = true

    def teardown
      RedisWrapper.instance = MockRedis.new
    end
  end
end
