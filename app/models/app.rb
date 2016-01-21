# App
class App < ActiveRecord::Base
  validates :app_name, presence: true
end
