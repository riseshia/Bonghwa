# Firewood
class Firewood < ActiveRecord::Base
  belongs_to :user
  belongs_to :attach

  before_create do |firewood|
    firewood.is_dm ||= 0
    firewood.attach_id ||= 0
    firewood.mt_root ||= 0
  end
end
