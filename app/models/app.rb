# App
class App < ActiveRecord::Base
  include FromJsonable
  validates :app_name, presence: true

  def first
    app = $redis.get("#{$servername}:app-data")
    if $redis.get("#{$servername}:app-data")
      app
    else
      super
    end
  end
end
