# frozen_string_literal: true
# Link
class Link < ActiveRecord::Base
  after_save :add_to_redis
  after_destroy :remove_from_redis

  def self.all_with_cache
    links = $redis.zrange("#{$servername}:app-links", 0, -1)
    if links.empty?
      links = all.map do |raw|
        $redis.zadd("#{$servername}:app-links", raw.id, raw.to_json)
        raw.to_json
      end
    end
    links.map { |link| Link.new(JSON.parse(link)) }
  end

  private

  def add_to_redis
    remove_from_redis
    $redis.zadd("#{$servername}:app-links", id, to_json)
  end

  def remove_from_redis
    $redis.zremrangebyscore("#{$servername}:app-links", id, id)
  end
end
