# frozen_string_literal: true

# Allows users to start new discussion topics on the forum.
class Topic < ApplicationRecord
  attr_accessor :description, :migration_flag

  # Concerns
  include Deletable
  include PgSearch
  include Replyable
  include UrlCountable
  multisearchable against: [:title],
                  unless: :deleted?

  # Callbacks
  after_create_commit :create_first_reply

  # Scopes
  scope :reply_count, -> { select('topics.*, COUNT(replies.id) reply_count').joins(:replies).group('topics.id') }
  scope :shadow_banned, -> (arg) { joins(:user).merge(User.where(shadow_banned: [nil, false]).or(User.where(id: arg))) }

  # Validations
  validates :title, :slug, :user_id, presence: true
  validates :description, presence: true, if: :requires_description?
  validates :slug, uniqueness: { scope: :deleted }
  validates :slug, format: { with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/ }

  # Relationships
  belongs_to :user
  has_many :topic_users
  # has_many :replies, -> { order :created_at }
  # has_many :reply_users

  # Methods
  def destroy
    super
    update_pg_search_document
    replies.each(&:update_pg_search_document)
  end

  def to_param
    slug_was.to_s
  end

  def started_reading?(current_user)
    topic_user = topic_users.find_by user: current_user
    topic_user ? true : false
  end

  def unread_replies(current_user)
    topic_user = topic_users.find_by user: current_user
    if topic_user
      root_replies.current.where('id > ?', topic_user.current_reply_read_id).count
    else
      0
    end
  end

  def next_unread_reply(current_user)
    topic_user = topic_users.find_by user: current_user
    root_replies.current.find_by('id > ?', topic_user.current_reply_read_id) if topic_user
  end

  def root_replies
    replies.where(reply_id: nil)
  end

  def editable_by?(current_user)
    user == current_user || current_user.moderator? || current_user.owner?
  end

  def last_page
    ((replies.where(reply_id: nil).count - 1) / Reply::REPLIES_PER_PAGE) + 1
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

  private

  def create_first_reply
    replies.create description: description, user_id: user_id if description.present?
  end

  def requires_description?
    new_record? && migration_flag != '1'
  end
end
