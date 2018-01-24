# frozen_string_literal: true

# Tracks subscriptions to notifications for forum topics.
class Subscription < ApplicationRecord
  # Validations
  validates :user_id, uniqueness: { scope: :topic_id }

  # Relationships
  belongs_to :topic
  belongs_to :user
end
