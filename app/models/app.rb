# frozen_string_literal: true
# App
class App < ApplicationRecord
  after_save :add_to_redis

  validates :app_name, presence: true

  def self.first_with_cache
    app = RedisWrapper.get("app-data")
    if app.nil?
      app = first.to_json
      RedisWrapper.set("app-data", app)
    end
    App.new(JSON.parse(app))
  end

  def add_to_redis
    RedisWrapper.set("app-data", to_json)
  end

  def script_enabled?
    use_script == 1
  end
end
