# frozen_string_literal: true
# Link
class Link < ActiveRecord::Base
  after_save :add_to_redis
  after_destroy :remove_from_redis

  def self.all_with_cache
    links = RedisWrapper.zrange("app-links", 0, -1)
    if links.empty?
      links = all.map do |raw|
        RedisWrapper.zadd("app-links", raw.id, raw.to_json)
        raw.to_json
      end
    end
    links.map { |link| Link.new(JSON.parse(link)) }
  end

  private

  def add_to_redis
    remove_from_redis
    RedisWrapper.zadd("app-links", id, to_json)
  end

  def remove_from_redis
    RedisWrapper.zremrangebyscore("app-links", id, id)
  end
end
