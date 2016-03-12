# App
class App < ActiveRecord::Base
  include FromJsonable

  after_save :add_to_redis

  validates :app_name, presence: true

  def self.first_with_cache
    app = $redis.get("#{$servername}:app-data")
    if app.nil?
      app = first.to_json
      $redis.set("#{$servername}:app-data", app)
    end
    App.new(JSON.parse(app))
  end

  def add_to_redis
    $redis.set("#{$servername}:app-data", self.to_json)
  end
end
