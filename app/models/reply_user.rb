# frozen_string_literal: true

# Represents a user vote on a blog comment.
class ReplyUser < ActiveRecord::Base
  # Model Validation
  validates :chapter_id, :reply_id, :user_id, :vote, presence: true

  # Model Relationships
  belongs_to :user
  belongs_to :chapter
  belongs_to :reply

  # Model Methods
  def up_vote!
    update vote: 1
  end

  def down_vote!
    update vote: -1
  end

  def remove_vote!
    update vote: 0
  end
end
