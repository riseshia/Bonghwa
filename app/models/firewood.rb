# frozen_string_literal: true
# Firewood
class Firewood < ActiveRecord::Base
  # Callback
  before_create :default_values
  before_create :attachment_support
  before_destroy :destroy_attach

  around_create :send_dm, if: Proc.new { |fw| fw.dm? && !fw.system_dm? }

  after_create :execute_cmd, if: :cmd?
  after_create :add_to_redis
  before_destroy :remove_from_redis

  belongs_to :user
  belongs_to :attach

  attr_accessor :attached_file, :adult_check, :app, :user

  # Scope
  def self.find_mt(prev_mt, user_id)
    where("(id = ?) AND (is_dm = 0 OR is_dm = ?)", prev_mt, user_id).order("id DESC").limit(1)
  end

  # Public Method
  def self.timeline_with_cache(user)
    firewoods = $redis.zrange("#{$servername}:fws", 0, -1).map do |fw|
      Firewood.new(JSON.parse(fw))
    end.select do |fw|
      fw.visible? user.id
    end
  end

  def self.after_than(after_id, user)
    $redis.zrevrangebyscore("#{$servername}:fws", "+inf", "(#{after_id}").map do |fw|
      Firewood.new(JSON.parse(fw))
    end.select do |fw|
      fw.visible? user.id
    end
  end

  def cmd?
    contents.match("^/.+").present?
  end

  def dm?
    !normal? || contents.match("^!.+").present?
  end

  def system_dm?
    dm? && user_id == 0
  end

  def normal?
    is_dm == 0
  end

  def visible?(session_user_id)
    normal? || is_dm == session_user_id || user_id == session_user_id
  end

  def to_hash_for_api
    {
      "id" => id, "is_dm" => is_dm,
      "mt_root" => mt_root,
      "prev_mt" => prev_mt,
      "user_id" => user_id,
      "name" => user_name,
      "contents" => contents,
      "img_link" => img_link,
      "created_at" => created_at.strftime("%D %T")
    }
  end

  def img_link
    attach_id != 0 ? attach.img.url : "0"
  end

  def editable?(user)
    user_id == user.id
  end

  # Class Method
  def self.system_dm(params)
    create(
      user_id: 0,
      user_name: "System",
      contents: params[:message],
      is_dm: params[:user_id]
    )
  end

  private

  def add_to_redis
    $redis.zadd("#{$servername}:fws", id, to_json)

    return true unless normal?
    return true if $redis.zrange("#{$servername}:fws", 0, -1).size < 50
    loop do
      last_fw = $redis.zrange("#{$servername}:fws", 0, 0).first
      $redis.zremrangebyrank("#{$servername}:fws", 0, 0)
      last_idx = JSON.parse(last_fw)['id']
      break if Firewood.find(last_idx).normal?
    end
  end

  def remove_from_redis
    $redis.zremrangebyscore("#{$servername}:fws", id, id)

    cached = $redis.zrange("#{$servername}:fws", 0, 0)
    if normal? && cached.present?
      idx = JSON.parse(cached.first)["id"] - 1
      loop do
        break if idx == 0
        unless Firewood.exists?(id: idx)
          idx -= 1
          next
        end
        fw = Firewood.find(idx)
        $redis.zadd("#{$servername}:fws", fw.id, fw.to_json)
        break if fw.normal?
      end
    end
  end

  def default_values
    self.is_dm ||= 0
    self.attach_id ||= 0
    self.mt_root ||= 0
    self.prev_mt ||= 0
  end

  def destroy_attach
    attach.destroy if attach.present?
  end

  def attachment_support
    raise "내용이 없습니다." if contents.blank? && attached_file.blank?

    if attached_file.present?
      attach = Attach.create!(img: attached_file)
      self.attach_id = attach.id
      if adult_check
        self.contents += " <span class='has-image text-warning'>[후방주의 #{attach.id}]</span>"
      else
        self.contents += " <span class='has-image'>[이미지 #{attach.id}]</span>"
      end
    end
  end

  def send_dm
    fw_parsed = self.contents.match('^!(\S+)\s(.+)') # parsing
    enable_to_send = true
    message = ""
    if fw_parsed.nil?
      message = "잘못된 DM 명령입니다. '!상대 보내고 싶은 내용'이라는 양식으로 작성해주세요."
      enable_to_send = false
    else
      dm_user = User.find_by_name(fw_parsed[1]) # user check
      if dm_user.nil?
        message = "존재하지 않는 상대입니다. 정확한 닉네임으로 보내보세요."
        enable_to_send = false
      end
    end

    self.is_dm = enable_to_send ? dm_user.id : user_id

    yield

    Firewood.system_dm(user_id: user_id, message: message) if !enable_to_send && user_id != 0
  end

  def execute_cmd
    Scripter.execute(firewood: self, user: User.find(user_id))
  end
end
