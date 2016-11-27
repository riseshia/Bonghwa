# frozen_string_literal: true
ENV["RAILS_ENV"] = "test"
require "simplecov"
require "coveralls"
SimpleCov.start "rails" do
  add_filter "/spec/"
  add_filter "/test/"
  add_filter "/config/"
end
Coveralls.wear!

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/pride"

Dir[Rails.root.join("test/supports/**/*.rb")].each { |f| require f }

module ActiveSupport
  class TestCase
    def setup
      DatabaseRewinder.clean_all
    end

    def teardown
      DatabaseRewinder.clean
    end
  end
end
