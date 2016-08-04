# frozen_string_literal: true

# Allows community members to reply to forum topics. Replies can also be nested
# under other replies.
class Reply < ApplicationRecord
  # Constants
  THRESHOLD = -10

  # Concerns
  include Deletable
  include PgSearch
  multisearchable against: [:description],
                  unless: :deleted_or_chapter_deleted?

  # Scopes
  scope :points, -> { select('replies.*, COALESCE(SUM(reply_users.vote), 0)  points').joins('LEFT JOIN reply_users ON reply_users.reply_id = replies.id').group('replies.id') }

  # Model Validation
  validates :description, :user_id, :chapter_id, presence: true

  # Model Relationships
  belongs_to :user
  belongs_to :chapter
  belongs_to :reply
  has_many :reply_users

  # Model Methods
  def destroy
    super
    update_pg_search_document
  end

  def deleted_or_chapter_deleted?
    deleted? || chapter.deleted?
  end

  def read?(current_user)
    chapter_user = chapter.chapter_users.find_by user: current_user
    if chapter_user && chapter_user.last_reply_read_id.to_i >= id
      true
    else
      false
    end
  end

  def display_links?
    rank >= 0
  end

  def parent
    chapter # || broadcast
  end

  def number
    chapter.replies.where(reply_id: nil).pluck(:id).index(id) + 1
  rescue
    0
  end

  def page
    if reply
      reply.page
    else
      ((number - 1) / Chapter::REPLIES_PER_PAGE) + 1
    end
  end

  def anchor
    "comment-#{id}"
  end

  def chapter_author?
    chapter.user_id == user_id
  end

  def rank
    @rank ||= reply_users.sum(:vote)
  end

  def reverse_rank
    -rank
  end

  def order_newest
    -id
  end

  def order_oldest
    id
  end

  def order_best
    [reverse_rank, order_newest]
  end

  def below_threshold?
    deleted? || rank < THRESHOLD || user.shadow_banned?
  end

  def vote(current_user)
    reply_user = reply_users.find_by(user: current_user)
    return nil unless reply_user
    case reply_user.vote
    when 1
      true
    when -1
      false
    end
  end

  def parent_comment_id
    reply_id || 'root'
  end

  def computed_level
    return 0 if reply_id.nil?
    reply.computed_level + 1
  end

  def editable_by?(current_user)
    current_user.editable_replies.where(id: id).count == 1
  end

  def create_notifications!
    if reply
      notify_comment_author
    else
      notify_chapter_author
    end
  end

  def notify_comment_author
    return if reply.user == user
    notification = reply.user.notifications.where(chapter_id: chapter_id, reply_id: id).first_or_create
    notification.mark_as_unread!
  end

  def notify_chapter_author
    return if chapter.user == user
    notification = chapter.user.notifications.where(chapter_id: chapter_id, reply_id: id).first_or_create
    notification.mark_as_unread!
  end
end
