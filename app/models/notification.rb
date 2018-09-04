# frozen_string_literal: true

# Tracks if a user has seen replies to blog posts and forum topics.
class Notification < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :broadcast, optional: true
  belongs_to :topic, optional: true
  belongs_to :reply, optional: true
  belongs_to :admin_export, optional: true, class_name: "Admin::Export"

  # Methods

  def mark_as_unread!
    update created_at: Time.zone.now, read: false
  end
end
