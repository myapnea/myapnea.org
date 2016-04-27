# frozen_string_literal: true

# Allows community members to discuss blog posts. Comments can also be nested
# under other comments.
class BroadcastComment < ActiveRecord::Base
  # Constants
  THRESHOLD = -10

  # Concerns
  include Deletable

  # Named Scopes

  # Model Validation
  validates :description, :user_id, :broadcast_id, presence: true

  # Model Relationships
  belongs_to :user
  belongs_to :broadcast
  belongs_to :broadcast_comment

  # Model Methods

  def rank
    # @rank ||= rand(101) - 50
    12
  end

  def below_threshold?
    deleted? || rank < THRESHOLD
  end

  def vote(current_user)
    return nil
    if current_user
      true
    elsif true
      false
    else
      nil
    end
  end

  def parent_comment_id
    broadcast_comment_id || 'root'
  end
end
