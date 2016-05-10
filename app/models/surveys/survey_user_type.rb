# frozen_string_literal: true

class SurveyUserType < ActiveRecord::Base

  # Concerns
  include Deletable

  # Model Validation
  validates_presence_of :survey_id, :user_id, :user_type
  validates_uniqueness_of :user_type, scope: [ :survey_id, :deleted ]
  validates_inclusion_of :user_type, in: User::TYPES.collect(&:last)

  # Model Relationships
  belongs_to :user
  belongs_to :survey

  # Model Methods

end
