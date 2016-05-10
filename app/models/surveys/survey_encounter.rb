# frozen_string_literal: true

class SurveyEncounter < ActiveRecord::Base

  # Concerns

  # Model Validation
  validates_presence_of :survey_id, :encounter_id, :user_id
  validates_uniqueness_of :encounter_id, scope: [ :survey_id ]

  # Model Relationships
  belongs_to :survey
  belongs_to :encounter
  belongs_to :user
  belongs_to :parent_survey_encounter, class_name: "SurveyEncounter", foreign_key: 'parent_survey_encounter_id'

  # Model Methods

  def survey_encounter_name
    "#{self.survey.name}: #{self.encounter.name}"
  end

  def encounter_survey_name
    "#{self.encounter.name}: #{self.survey.name}"
  end

end
