# frozen_string_literal: true

class Engagement < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :engagement_responses

  # Concerns
  include Deletable

  # Methods
  def name
    "##{id}"
  end

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
