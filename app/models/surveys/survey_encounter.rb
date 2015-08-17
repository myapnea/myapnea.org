class SurveyEncounter < ActiveRecord::Base

  # Concerns

  # Model Validation
  validates_presence_of :survey_id, :encounter_id, :user_id
  validates_uniqueness_of :encounter_id, scope: [ :survey_id ]

  # Model Relationships
  belongs_to :survey
  belongs_to :encounter
  belongs_to :user

  # Model Methods

end
