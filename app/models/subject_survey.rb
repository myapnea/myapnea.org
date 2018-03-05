# frozen_string_literal: true

# Tracks survey completion.
class SubjectSurvey < ApplicationRecord
  # Validations
  validates :subject_id, uniqueness: { scope: [:event, :design] }

  # Relationships
  belongs_to :subject

  # Methods

  def completed?
    !completed_at.nil?
  end
end
