# frozen_string_literal: true

# Tracks if a user has seen replies to blog and forum posts and comments.
class Notification < ActiveRecord::Base
  # Model Validation
  validates :user_id, presence: true

  # Model Relationships
  belongs_to :user
  belongs_to :broadcast
  belongs_to :broadcast_comment

  # Notification Methods

  def mark_as_unread!
    update created_at: Time.zone.now, read: false
  end
end
