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
  has_many :favorites
  has_many :faved_users, through: :favorites, source: :user

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
  scope :faved, (lambda { |user, limit|
    includes(:favorites)
      .where(favorites: { user_id: user.id })
      .order_by_id
      .limit(limit)
  })
  scope :mts_of, (lambda { |root_mt_id, user_id, target_id, limit_num = 5|
    after_or_equal(root_mt_id)
      .before(target_id)
      .where(root_mt_id: root_mt_id)
      .or(where(id: root_mt_id))
      .visible_by(user_id)
      .order_by_id
      .limit(limit_num)
  })
  scope :with_fav_for_user, (lambda { |user_id|
    left_joins(:favorites)
      .select("firewoods.*, favorites.user_id AS fav_user_id")
  })
  scope :order_by_id, (-> { order(id: :desc) })
  scope :after, (->(id = nil) { where("firewoods.id > ?", id) if id })
  scope :after_or_equal, (->(id = nil) { where("firewoods.id >= ?", id) if id })
  scope :before, (->(id = nil) { where("firewoods.id < ?", id) if id })

  # Private Scope
  scope :visible_by, (lambda { |user_id|
    where(is_dm: [0, user_id])
      .or(where(user_id: user_id))
  })

  validates :image, file_size: { less_than: 6.megabytes }
  validate :validate_dm, on: :dm

  TYPE_TO_SCOPE = {
    "1" => :trace,
    "2" => :mention,
    "3" => :me,
    "4" => :faved
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
  def serialize(user)
    {
      id: id,
      is_dm: is_dm,
      prev_mt_id: prev_mt_id,
      root_mt_id: root_mt_id,
      user_id: user_id,
      name: ERB::Util.html_escape(user_name),
      contents: ERB::Util.html_escape(contents),
      is_faved: self[:fav_user_id] == user.id ? true : false,
      image_url: image_url_with_host,
      image: serialized_image,
      sensitive_flg: sensitive_flg,
      created_at: formatted_created_at
    }
  end

  def serialized_image
    return nil unless image_url
    {
      url: image_url,
      name: image_name
    }
  end

  def image_url_with_host
    ENV["BW_IMAGE_HOST"] + image_url if image_url
  end

  def image_name
    image.file.filename
  end
end
