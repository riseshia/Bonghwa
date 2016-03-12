begin
  $redis = Redis.new(:host => Rails.application.secrets.redis_host, :port => Rails.application.secrets.redis_port)
  $servername = Rails.env
  # $redis.del("#{$servername}:fws")
  # $redis_cache_size = 500

  # Clean Redis
  $redis.del("#{$servername}:app-data")

  # Preload Firewoods
  # Firewood.all.order("id DESC").limit($redis_cache_size).each do |fw|
  #   $redis.zadd("#{$servername}:fws", fw.id, JSON.dump(fw.to_json))
  # end
rescue
end