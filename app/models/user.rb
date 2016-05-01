# frozen_string_literal: true
# User
class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :login_id, presence: true, uniqueness: true
  has_secure_password

  has_many :firewoods

  def admin?
    level == 999
  end

  def update_nickname(new_name)
    old_user_name = name
    self.name = new_name
    state = save
    if state
      RedisWrapper.zrem("active-users", old_user_name)
      RedisWrapper.zadd("active-users", Time.zone.now.to_i, name)
      RedisWrapper.set("session-#{id}", to_json)
      RedisWrapper.expire("session-#{id}", 86_400)
    end
    state
  end
end
