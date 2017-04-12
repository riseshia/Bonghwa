# frozen_string_literal: true

require "test_helper"

class AppTest < ActiveSupport::TestCase
  validate_presence_of(:app_name)

  def test_first_with_cache_when_exist
    apps(:bonghwa)
    assert App.first_with_cache
  end

  def test_first_with_cache_when_not_exist
    apps(:bonghwa)
    RedisWrapper.set("app-data", {})
    assert App.first_with_cache
  end

  def test_add_to_redis_after_save
    app = App.new(
      home_name: "Bonghwa",
      home_link: "/",
      app_name: "App",
      use_script: 1
    )
    mock = MiniTest::Mock.new
    mock.expect :call, true
    RedisWrapper.stub(:set, "app-data", app.to_json) { mock.call }

    app.save

    assert mock.verify
  end

  def test_script_enabled_returns_true
    app = App.new(use_script: 1)
    assert app.script_enabled?
  end

  def test_script_enabled_returns_false
    app = App.new(use_script: 0)
    refute app.script_enabled?
  end
end
