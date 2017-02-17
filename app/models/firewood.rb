# frozen_string_literal: true
# Firewood
class Firewood < ApplicationRecord
  belongs_to :user, optional: true # for bot handling

  mount_uploader :image, ImageUploader
  delegate :url, to: :image, prefix: true, allow_nil: true

  # Public Scope
  scope :mention, lambda { |user_id, user_name, count|
    where("is_dm = ? OR contents like ?", user_id, "%@#{user_name}%")
      .order_by_id
      .limit(count)
  }
  scope :me, lambda { |user_id, limit|
    where(user_id: user_id).order_by_id.limit(limit)
  }
  scope :trace, lambda { |user_id, limit|
    visible_by(user_id).order_by_id.limit(limit)
  }
  scope :mts_of, lambda { |root_mt_id, user_id, target_id, limit_num = 5|
    before(target_id)
      .where("root_mt_id = :fw_id OR id = :fw_id", fw_id: root_mt_id)
      .visible_by(user_id)
      .order_by_id
      .limit(limit_num)
  }
  scope :order_by_id, -> { order(id: :desc) }
  scope :after, ->(id) { where("id > ?", id) }
  scope :before, ->(id) { where("id < ?", id) }

  # Private Scope
  scope :visible_by, lambda { |user_id|
    where("is_dm IN (0, :user_id) OR user_id = :user_id", user_id: user_id)
  }

  validates :image, file_size: { less_than: 5.megabytes }

  # Class Method
  def self.system_dm(params)
    create(
      user_id: 0,
      user_name: "System",
      contents: params[:message],
      is_dm: params[:user_id]
    )
  end

  def cmd?
    %r{^\/.+}.match?(contents)
  end

  def dm?
    !normal? || /^!.+/.match?(contents)
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

  def editable?(user)
    user_id == user.id
  end

  def formatted_created_at
    created_at.strftime("%y/%m/%d %T")
  end
end
