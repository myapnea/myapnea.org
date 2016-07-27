# frozen_string_literal: true

# Tracks how far has read through a forum topic.
class ChapterUser < ApplicationRecord
  # Model Validation
  validates :chapter_id, :user_id, presence: true
  validates :user_id, uniqueness: { scope: :chapter_id }

  # Model Relationships
  belongs_to :chapter
  belongs_to :user
end
