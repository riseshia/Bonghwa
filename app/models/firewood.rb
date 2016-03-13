# Firewood
class Firewood < ActiveRecord::Base
  # Callback
  before_create :default_values
  before_create :attachment_support
  before_destroy :destroy_attach

  around_create :send_dm, if: :dm?

  after_create :execute_cmd, if: :cmd?
  after_save :add_to_redis
  after_destroy :remove_from_redis

  belongs_to :user
  belongs_to :attach

  attr_accessor :attached_file, :adult_check, :app, :user

  # Scope
  def self.find_mt(prev_mt, user_id)
    where('(id = ?) AND (is_dm = 0 OR is_dm = ?)', prev_mt, user_id).order('id DESC').limit(1)
  end

  # Public Method
  def self.timeline_with_cache(user)
    firewoods = $redis.zrange("#{$servername}:fws", 0, -1).map do |fw|
      Firewood.new(JSON.parse(fw))
    end.select do |fw|
      fw.visible? user.id
    end
  end

  def self.after_than(after_id)
    $redis.zrevrangebyscore("#{$servername}:fws", '+inf', "(#{after_id}").map do |fw|
      Firewood.new(JSON.parse(fw))
    end
  end

  def cmd?
    self.contents.match('^/.+').present?
  end

  def dm?
    !normal? || self.contents.match('^!.+').present?
  end

  def normal?
    self.is_dm == 0
  end

  def visible?(session_user_id)
    normal? || self.is_dm == session_user_id || self.user_id == session_user_id
  end

  def to_hash_for_api
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

  # Class Method
  def self.system_dm(params)
    create(
      user_id: 0,
      user_name: 'System',
      contents: params[:message],
      is_dm: params[:user_id]
    )
  end

  private

  def add_to_redis
    $redis.zadd("#{$servername}:fws", self.id, self.to_json)
    $redis.zremrangebyrank("#{$servername}:fws", 0, 0) if self.normal?
  end

  def remove_from_redis
    $redis.zremrangebyscore("#{$servername}:fws", self.id, self.id)

    cached = $redis.zrange("#{$servername}:fws", 0, 0)
    if self.normal? && cached.present?
      idx = JSON.parse(cached.first)['id'] - 1
      loop do
        fw = Firewood.find(idx)
        if fw.nil?
          idx -= 1
          next
        end

        $redis.zadd("#{$servername}:fws", fw.id, fw.to_json)
        break if self.normal?
      end
    end
  end

  def default_values
    self.is_dm ||= 0
    self.attach_id ||= 0
    self.mt_root ||= 0
  end

  def destroy_attach
    self.attach.destroy if self.attach.present?
  end

  def attachment_support
    fail '내용이 없습니다.' if self.contents.blank? && self.attached_file.blank?

    if self.attached_file.present?
      attach = Attach.create!(img: self.attached_file)
      self.attach_id = attach.id
      if self.adult_check
        self.contents += " <span class='has-image text-warning'>[후방주의 #{attach.id}]</span>"
      else
        self.contents += " <span class='has-image'>[이미지 #{attach.id}]</span>"
      end
    end
  end

  def send_dm
    fw_parsed = self.contents.match('^!(\S+)\s(.+)') # parsing
    enable_to_send = true
    message = ''
    if fw_parsed.nil?
      message = "잘못된 DM 명령입니다. '!상대 보내고 싶은 내용'이라는 양식으로 작성해주세요."
      enable_to_send = false
    else
      dm_user = User.find_by_name(fw_parsed[1]) # user check
      if dm_user.nil?
        message = '존재하지 않는 상대입니다. 정확한 닉네임으로 보내보세요.'
        enable_to_send = false
      end
    end

    self.is_dm = enable_to_send ? dm_user.id : self.user_id

    yield

    Firewood.system_dm(user_id: self.user_id, message: message) if !enable_to_send && self.user_id != 0
  end

  def execute_cmd
    Scripter.execute(firewood: self, user: User.find(user_id))
  end
end
