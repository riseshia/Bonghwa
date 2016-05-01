# frozen_string_literal: true
# Info
class Info < ActiveRecord::Base
  after_create :add_to_redis
  after_destroy :remove_from_redis

  def self.all_with_cache
    infos = RedisWrapper.zrange("app-infos", 0, -1)
    if infos.empty?
      infos = all.map do |raw|
        RedisWrapper.zadd("app-infos", raw.id, raw.to_json)
        raw.to_json
      end
    end
    infos.map { |info| Info.new(JSON.parse(info)) }
  end

  def add_to_redis
    remove_from_redis
    RedisWrapper.zadd("app-infos", id, to_json)
  end

  def remove_from_redis
    RedisWrapper.zremrangebyscore("app-infos", id, id)
  end
end
