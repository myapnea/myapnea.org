# frozen_string_literal: true

# TODO: Deprecated in v17.0.0

# Allows community members to discuss blog posts. Comments can also be nested
# under other comments.
class BroadcastComment < ApplicationRecord
  # Constants
  THRESHOLD = -10

  # Concerns
  include Deletable

  # Scopes
  scope :points, -> { select('broadcast_comments.*, COALESCE(SUM(broadcast_comment_users.vote), 0)  points').joins('LEFT JOIN broadcast_comment_users ON broadcast_comment_users.broadcast_comment_id = broadcast_comments.id').group('broadcast_comments.id') }

  # Model Validation
  validates :description, :user_id, :broadcast_id, presence: true

  # Model Relationships
  belongs_to :user
  belongs_to :broadcast
  belongs_to :broadcast_comment
  has_many :broadcast_comment_users

  # Model Methods
  def destroy
    super
    update_pg_search_document
  end

  def deleted_or_broadcast_deleted?
    deleted? || broadcast.deleted?
  end

  def display_links?
    rank >= 0
  end

  def rank
    @rank ||= broadcast_comment_users.sum(:vote)
  end

  def reverse_rank
    -rank
  end

  def order_newest
    -id
  end

  def order_best
    [reverse_rank, order_newest]
  end

  def below_threshold?
    deleted? || rank < THRESHOLD
  end

  def vote(current_user)
    broadcast_comment = broadcast_comment_users.find_by(user: current_user)
    return nil unless broadcast_comment
    case broadcast_comment.vote
    when 1
      true
    when -1
      false
    end
  end

  def computed_level
    return 0 if broadcast_comment_id.nil?
    broadcast_comment.computed_level + 1
  end

  def editable_by?(current_user)
    current_user.editable_broadcast_comments.where(id: id).count == 1
  end

  def create_notifications!
    if broadcast_comment
      notify_comment_author
    else
      notify_blog_author
    end
  end

  def notify_comment_author
    return if broadcast_comment.user == user
    notification = broadcast_comment.user.notifications.where(broadcast_id: broadcast_id, broadcast_comment_id: id).first_or_create
    notification.mark_as_unread!
  end

  def notify_blog_author
    return if broadcast.user == user
    notification = broadcast.user.notifications.where(broadcast_id: broadcast_id, broadcast_comment_id: id).first_or_create
    notification.mark_as_unread!
  end
end
