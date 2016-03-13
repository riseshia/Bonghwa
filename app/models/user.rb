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
    old_user_name = self.name
    self.name = new_name
    state = self.save
    if state
      $redis.zrem("#{$servername}:active-users", old_user_name)
      $redis.zadd("#{$servername}:active-users", Time.zone.now.to_i, self.name)
      $redis.set("#{$servername}:session-#{self.id}", self.to_json)
      $redis.expire("#{$servername}:session-#{self.id}", 86_400)
    end
    state
  end
end
