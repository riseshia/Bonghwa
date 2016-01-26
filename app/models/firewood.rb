# Firewood
class Firewood < ActiveRecord::Base
  belongs_to :user
  belongs_to :attach

  before_create do |firewood|
    firewood.is_dm ||= 0
    firewood.attach_id ||= 0
    firewood.mt_root ||= 0
  end

  def normal?
    is_dm == 0
  end

  def to_json
    {
      'id' => id, 'is_dm' => is_dm,
      'mt_root' => mt_root,
      'prev_mt' => prev_mt,
      'user_id' => user_id,
      'name' => user_name,
      'contents' => contents,
      'img_link' => img_link,
      'created_at' => created_at.strftime('%D %T')
    }
  end

  def img_link
    if attach_id != 0
      attach.img.url
    else
      '0'
    end
  end

  def editable?(user)
    user_id == user.id
  end
end
