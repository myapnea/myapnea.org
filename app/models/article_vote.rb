# frozen_string_literal: true

# Allows users to rate articles as helpful or not helpful.
class ArticleVote < ApplicationRecord
  # Validations
  validates :user_id, uniqueness: { scope: :article_id }

  # Relationships
  belongs_to :user
  belongs_to :article, class_name: "Broadcast"

  # Methods
  def up_vote!
    update rating: 1
  end

  def down_vote!
    update rating: -1
  end

  def remove_vote!
    update rating: 0
  end
end
