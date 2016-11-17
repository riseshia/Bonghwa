# frozen_string_literal: true
# Firewood
class Firewood < ApplicationRecord
  # Callback
  before_create :default_values
  before_create :attachment_support
  before_destroy :destroy_attach

  belongs_to :user, optional: true # for bot handling
  belongs_to :attach, optional: true

  attr_accessor :attached_file, :adult_check

  # Scope
  scope :mention, lambda { |user_id, user_name, count|
    where("is_dm = ? OR contents like ?", user_id, "%@" + user_name + "%")
      .order("id DESC").limit(count)
  }
  scope :me, lambda { |user_id, limit|
    where(user_id: user_id).order("id DESC").limit(limit)
  }
  scope :after, ->(after) { where("id > ?", after) }
  scope :before, ->(before) { where("id < ?", before) }
  scope :trace, lambda { |user_id, limit|
    where("is_dm = 0 OR is_dm = ? OR user_id = ?", user_id, user_id)
      .order("id DESC").limit(limit)
  }

  def self.find_mt(prev_mt, user_id)
    where("(id = ?) AND (is_dm = 0 OR is_dm = ?)", prev_mt, user_id)
      .order("id DESC").limit(1)
  end

  def cmd?
    contents.match("^/.+").present?
  end

  def dm?
    !normal? || contents.match("^!.+").present?
  end

  def system_dm?
    dm? && user_id.zero?
  end

  def normal?
    is_dm.zero?
  end

  def visible?(session_user_id)
    normal? || is_dm == session_user_id || user_id == session_user_id
  end

  def to_hash_for_api
    {
      "id" => id,
      "is_dm" => is_dm,
      "mt_root" => mt_root,
      "prev_mt" => prev_mt,
      "user_id" => user_id,
      "name" => user_name,
      "contents" => contents,
      "img_id" => attach_id,
      "img_adult_flg" => attach&.adult_flg,
      "img_link" => img_link,
      "created_at" => created_at.strftime("%D %T")
    }
  end

  def img_link
    attach_id.zero? ? "0" : attach.img.url
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
      attach = Attach.create!(img: attached_file, adult_flg: adult_check == "true")
      self.attach_id = attach.id
    end
  end
end
