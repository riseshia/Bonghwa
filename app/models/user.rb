# User
class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :login_id, presence: true, uniqueness: true
  has_secure_password

  has_many :firewoods
end
