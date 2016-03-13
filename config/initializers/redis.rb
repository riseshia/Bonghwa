begin
  $redis = Redis.new(:host => Rails.application.secrets.redis_host, :port => Rails.application.secrets.redis_port)
  $servername = Rails.env
  $redis_cache_size = 500

  # Clean Redis
  $redis.del("#{$servername}:fws")
  $redis.del("#{$servername}:app-data")
  $redis.del("#{$servername}:app-links")

  last = Firewood.where(is_dm: 0).offset(50).limit(1).first
  Firewood.where('id > ?', last.id).each do |fw|
    $redis.zadd("#{$servername}:fws", fw.id, fw.to_json)
  end
rescue
end