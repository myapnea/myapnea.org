# frozen_string_literal: true

# Allows users to start new discussion topics on the forum.
class Topic < ApplicationRecord
  # Constants
  ORDERS = {
    "replies" => "topics.replies_count",
    "replies desc" => "topics.replies_count desc",
    "views" => "topics.view_count",
    "views desc" => "topics.view_count desc",
    "latest" => "topics.last_reply_at desc",
    "oldest" => "topics.last_reply_at"
  }
  DEFAULT_ORDER = "topics.pinned desc, topics.last_reply_at desc, topics.id desc"

  AUTO_LOCK_IN = 100.years

  attr_accessor :description

  # Concerns
  include Deletable
  include PgSearch::Model
  include Replyable
  include Sluggable
  include UrlCountable
  multisearchable against: [:title],
                  unless: :deleted_or_shadow_banned?
  include Strippable
  strip :title

  # Callbacks
  after_create_commit :create_first_reply

  # Scopes
  scope :shadow_banned, ->(arg) do
    joins(:user).merge(
      User.where(shadow_banned: [nil, false])
      .or(User.where(id: arg))
    )
  end
  # Auto-lock after replies have ceased for some time.
  scope :not_auto_locked, -> { where(locked: false).where("DATE(last_reply_at) >= ?", Time.zone.today - AUTO_LOCK_IN) }
  scope :auto_locked, -> { where(locked: true).or(where("DATE(last_reply_at) < ?", Time.zone.today - AUTO_LOCK_IN)) }

  # Validations
  validates :title, presence: true
  validates :description, presence: true, if: :new_record?
  validates :slug, format: { with: /\A[a-z][a-z0-9\-]*\Z/ },
                   exclusion: { in: %w(new edit create update destroy research) },
                   uniqueness: true,
                   allow_nil: true

  # Relationships
  belongs_to :user
  has_many :topic_users
  has_many :subscriptions
  has_many :subscribers, -> { current.where(subscriptions: { subscribed: true }) },
           through: :subscriptions, source: :user
  # has_many :replies, -> { order :created_at }
  # has_many :reply_users

  # Methods
  def destroy
    update slug: nil
    super
    update_pg_search_document
    replies.each(&:update_pg_search_document)
  end

  def deleted_or_shadow_banned?
    deleted? || user.spammer? || user.shadow_banned?
  end

  def started_reading?(topic_user)
    topic_user ? true : false
  end

  def unread_replies(topic_user)
    return 0 unless topic_user
    root_replies.current.where("id > ?", topic_user.current_reply_read_id).count
  end

  def next_unread_reply(topic_user)
    return nil unless topic_user
    root_replies.current.find_by("id > ?", topic_user.current_reply_read_id)
  end

  def root_replies
    replies.where(reply_id: nil)
  end

  def editable_by?(current_user)
    (!auto_locked? && user == current_user) || current_user.moderator? || current_user.admin?
  end

  def last_page(current_user)
    if current_user&.admin?
      ((replies.where(reply_id: nil).count - 1) / Reply::REPLIES_PER_PAGE) + 1
    else
      ((replies.where(reply_id: nil).shadow_banned(current_user).count - 1) / Reply::REPLIES_PER_PAGE) + 1
    end
  end

  def compute_shadow_ban!
    user.update shadow_banned: true if user.shadow_banned.nil? && url_count > 1
  end

  def url_count
    (count_urls(title) * 2) + first_reply_url_count
  end

  def first_reply_url_count
    return 0 if replies.first.nil?
    replies.first.url_count
  end

  def reset_last_reply_at!
    last_reply_at = replies.reject(&:deleted_or_parent_deleted?).last&.created_at
    update(last_reply_at: last_reply_at) if last_reply_at
  end

  def get_or_create_subscription(current_user)
    current_user.subscriptions.where(topic_id: id).first_or_create
  end

  def set_subscription!(notify, current_user)
    get_or_create_subscription(current_user).update subscribed: notify
  end

  def subscribed?(current_user)
    current_user.subscriptions.where(topic_id: id, subscribed: true).count.positive?
  end

  def auto_locked?
    locked? || (last_reply_at && last_reply_at.to_date < Time.zone.today - AUTO_LOCK_IN)
  end

  def not_auto_locked?
    !auto_locked?
  end

  def generate_automatic_subscriptions!
    User.current.where(forum_auto_subscribed: true).find_each do |user|
      get_or_create_subscription(user).update subscribed: true
    end
    replies.first&.create_notifications!
  end

  private

  def create_first_reply
    replies.create description: description, user_id: user_id if description.present?
    get_or_create_subscription(user)
  end
end
