begin
  $redis = Redis.new(:host => Rails.application.secrets.redis_host, :port => Rails.application.secrets.redis_port)
  $servername = Rails.application.secrets.redis_servername
  $redis.del("#{$servername}:fws")
  $redis_cache_size = 500

  # Preload Firewoods
  Firewood.all.order("id DESC").limit($redis_cache_size).each do |fw|
    $redis.zadd("#{$servername}:fws",fw.id,Marshal.dump(fw))
  end
rescue
end