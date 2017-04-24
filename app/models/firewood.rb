# frozen_string_literal: true

# Firewood
class Firewood < ApplicationRecord
  belongs_to :user, optional: true # for bot handling
  belongs_to :root_mt, foreign_key: :root_mt_id,
                       class_name: "Firewood",
                       optional: true
  belongs_to :prev_mt, foreign_key: :prev_mt_id,
                       class_name: "Firewood",
                       optional: true
  belongs_to :dm_user, foreign_key: :is_dm,
                       class_name: "User",
                       optional: true

  mount_uploader :image, ImageUploader
  delegate :url, to: :image, prefix: true, allow_nil: true

  # Public Scope
  scope :mention, (lambda { |user, count|
    where("is_dm = ? OR contents like ?", user.id, "%@#{user.name}%")
      .order_by_id
      .limit(count)
  })
  scope :me, (lambda { |user, limit|
    where(user_id: user.id).order_by_id.limit(limit)
  })
  scope :trace, (lambda { |user, limit|
    visible_by(user.id).order_by_id.limit(limit)
  })
  scope :mts_of, (lambda { |root_mt_id, user_id, target_id, limit_num = 5|
    after_or_equal(root_mt_id)
      .before(target_id)
      .where("root_mt_id = :fw_id OR id = :fw_id", fw_id: root_mt_id)
      .visible_by(user_id)
      .order_by_id
      .limit(limit_num)
  })
  scope :order_by_id, (-> { order(id: :desc) })
  scope :after, (->(id = nil) { where("id > ?", id) if id })
  scope :after_or_equal, (->(id = nil) { where("id >= ?", id) if id })
  scope :before, (->(id = nil) { where("id < ?", id) if id })

  # Private Scope
  scope :visible_by, (lambda { |user_id|
    where("is_dm IN (0, :user_id) OR user_id = :user_id", user_id: user_id)
  })

  validates :image, file_size: { less_than: 6.megabytes }
  validate :validate_dm, on: :dm

  TYPE_TO_SCOPE = {
    "1" => :trace,
    "2" => :mention,
    "3" => :me
  }.freeze

  # Class Method
  def self.system_dm(params)
    create(
      user_id: 0,
      user_name: "System",
      contents: params[:message],
      is_dm: params[:user_id]
    )
  end

  def self.fetch_scope_for_type(type)
    TYPE_TO_SCOPE[type]
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
    created_at.strftime("%m/%d %T")
  end

  # rubocop:disable Metrics/MethodLength
  def serialize
    {
      id: id,
      is_dm: is_dm,
      prev_mt_id: prev_mt_id,
      root_mt_id: root_mt_id,
      user_id: user_id,
      name: ERB::Util.html_escape(user_name),
      contents: ERB::Util.html_escape(contents),
      image_url: image_url_with_host,
      image_adult_flg: image_adult_flg,
      created_at: formatted_created_at
    }
  end

  def image_url_with_host
    ENV["BW_IMAGE_HOST"] + image_url if image_url
  end
end
