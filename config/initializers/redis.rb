$redis = Redis.new(:host => 'localhost', :port => 6379)
$servername = "msm"
$redis.del("#{$servername}:fws")
$redis_cache_size = 500
# Preload Firewoods
Firewood.all.order("id DESC").limit($redis_cache_size).each do |fw|
  $redis.zadd("#{$servername}:fws",fw.id,Marshal.dump(fw))
end