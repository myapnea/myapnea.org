# frozen_string_literal: true

# Allows users to start new discussion topics on the forum.
class Chapter < ActiveRecord::Base
  # Concerns
  include Deletable

  # Named Scopes

  # Model Validation
  validates :title, :slug, :description, :user_id, presence: true
  validates :slug, uniqueness: { scope: :deleted }
  validates :slug, format: { with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/ }

  # Model Relationships
  belongs_to :user
  has_many :replies
  has_many :reply_users

  # Model Methods
  def to_param
    slug.to_s
  end

  def editable_by?(current_user)
    user == current_user || current_user.moderator? || current_user.owner?
  end
end
