class Firewood < ActiveRecord::Base
  attr_accessible :contents, :img_id, :is_dm, :mt_root, :prev_mt, :user_id, :user_name

  belongs_to :user
  belongs_to :attach

  before_create do |firewood|
    firewood.is_dm ||= 0
    firewood.attach_id ||= 0
    firewood.mt_root ||= 0
  end
end
