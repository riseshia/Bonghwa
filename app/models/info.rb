# Info
class Info < ActiveRecord::Base
  after_save :add_to_redis
  after_destroy :remove_from_redis

  def self.all_with_cache
    infos = $redis.zrange("#{$servername}:app-infos", 0, -1)
    if infos.empty?
      infos = all.map do |raw|
        $redis.zadd("#{$servername}:app-infos", raw.id, raw.to_json)
        raw.to_json
      end
    end
    infos.map { |info| Info.new(JSON.parse(info)) }
  end

  def add_to_redis
    remove_from_redis
    $redis.zadd("#{$servername}:app-infos", self.id, self.to_json)
  end

  def remove_from_redis
    $redis.zremrangebyscore("#{$servername}:app-infos", self.id, self.id)
  end
end
