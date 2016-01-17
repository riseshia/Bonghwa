# User
class User < ActiveRecord::Base
  attr_accessible :level, :login_id, :name, :password_digest, :recent_login, :password, :password_confirmation

  validates :name, :login_id, presence: true, uniqueness: true
  has_secure_password

  has_many :firewoods
end
