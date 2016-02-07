# Firewood
class Firewood < ActiveRecord::Base
  belongs_to :user
  belongs_to :attach

  # Callback
  before_create do |firewood|
    firewood.is_dm ||= 0
    firewood.attach_id ||= 0
    firewood.mt_root ||= 0
  end

  before_destroy do |firewood|
    firewood.attach.destroy if firewood.attach.present?
  end

  # Scope
  def self.find_mt(prev_mt, user_id)
    where('(id = ?) AND (is_dm = 0 OR is_dm = ?)', prev_mt, user_id).order('id DESC').limit(1)
  end

  # Public Method
  def normal?
    is_dm == 0
  end

  def visible? session_user_id
    normal? || is_dm == session_user_id || user_id == session_user_id
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
    attach_id != 0 ? attach.img.url : '0'
  end

  def editable?(user)
    user_id == user.id
  end

  def save_fw(params)
    fw = self
    begin
      fail '내용이 없습니다.' if fw.contents.size == 0 && params[:attach].size == 0

      Firewood.transaction do
        unless params[:attach].blank?
          @attach = Attach.create!(img: params[:attach])
          fw.attach_id = @attach.id
          if params[:adult_check]
            fw.contents += " <span class='has-image text-warning'>[후방주의 #{@attach.id}]</span>"
          else
            fw.contents += " <span class='has-image'>[이미지 #{@attach.id}]</span>"
          end
        end

        fw.save!
      end

      redis.zadd("#{servername}:fws", fw.id, Marshal.dump(fw))
      redis.zremrangebyrank("#{servername}:fws", 0, -1 * ($redis_cache_size - 1))
    rescue Exception => e
    end

    fw
  end

  private

  def redis
    $redis
  end

  def servername
    $servername
  end
end
