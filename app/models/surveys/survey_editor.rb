# frozen_string_literal: true

# Allows a user to edit an existing survey
class SurveyEditor < ApplicationRecord
  # Model Validation
  validates :survey_id, :creator_id, presence: true
  validates :user_id, presence: true

  # Model Relationships
  belongs_to :user
  belongs_to :survey
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  # Model Methods
end
