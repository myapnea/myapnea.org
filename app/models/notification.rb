# frozen_string_literal: true

# Tracks if a user has seen replies to blog and forum posts and comments.
class Notification < ApplicationRecord
  # Validations
  validates :user_id, presence: true

  # Relationships
  belongs_to :user
  belongs_to :broadcast
  belongs_to :topic
  belongs_to :reply

  # Methods

  def mark_as_unread!
    update created_at: Time.zone.now, read: false
  end
end
