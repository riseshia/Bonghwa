# frozen_string_literal: true

# RedisWrapper
module RedisWrapper
  module_function

  def setup
    @servername = Rails.env

    # Clean Redis
    instance.del("fws")
    instance.del("app-data")
    instance.del("app-links")
  end

  def instance
    @instance ||= Redis.new(
      host: Rails.application.secrets.redis_host,
      port: Rails.application.secrets.redis_port
    )
  end

  def instance=(ins)
    @instance = ins
  end

  def servername
    @servername
  end

  def zadd(key, order, value)
    instance.zadd("#{servername}:#{key}", order, value)
  end

  def zrem(key, value)
    instance.zrem("#{servername}:#{key}", value)
  end

  def zrangebyscore(key, before, now)
    instance.zrangebyscore("#{servername}:#{key}", before, now)
  end

  def set(key, value)
    instance.set("#{servername}:#{key}", value)
  end

  def get(key)
    instance.get("#{servername}:#{key}")
  end

  def expire(key, time)
    instance.expire("#{servername}:#{key}", time)
  end

  def del(key)
    instance.del("#{servername}:#{key}")
  end
end
