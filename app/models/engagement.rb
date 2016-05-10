# frozen_string_literal: true

class Engagement < ActiveRecord::Base
  # Default Scope
  # Constants
  # Attribute related macros
  # Associations
  belongs_to :user
  has_many :engagement_responses

  # Validations
  # Callback
  # Other macros
  # Concerns
  include Deletable

  # Named scopes
  # Methods
  def user_types
    User::TYPES.collect do |label, user_type|
      user_type if self[user_type]
    end.compact
  end

  def applicable_to?(user)
    (user.user_types & user_types).present?
  end

  def answered_by?(user)
    engagement_responses.where(user_id: user.id).present?
  end
end
