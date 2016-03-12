# App
class App < ActiveRecord::Base
  include FromJsonable
  validates :app_name, presence: true
end
