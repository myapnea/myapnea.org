class AddParentSurveyEncounterIdToSurveyEncounters < ActiveRecord::Migration
  def change
    add_column :survey_encounters, :parent_survey_encounter_id, :integer
    add_index :survey_encounters, :parent_survey_encounter_id
  end
end
