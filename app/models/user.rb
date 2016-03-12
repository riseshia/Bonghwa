# User
class User < ActiveRecord::Base
  include FromJsonable

  validates :name, presence: true, uniqueness: true
  validates :login_id, presence: true, uniqueness: true
  has_secure_password

  has_many :firewoods

  def admin?
    level == 999 ? true : false
  end
end
