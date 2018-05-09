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

  def update_cache!(event_design)
    update(
      design_name_cache: event_design.design_name,
      design_slug_cache: event_design.design_slug,
      event_slug_cache: event_design.event_slug
    )
  end
end
