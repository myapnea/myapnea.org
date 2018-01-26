class DropSurveyEncounters < ActiveRecord::Migration[5.2]
  def change
    drop_table :survey_encounters do |t|
      t.integer :survey_id
      t.integer :user_id
      t.integer :encounter_id
      t.integer :position, null: false, default: 0
      t.integer :parent_survey_encounter_id
      t.timestamps null: false
      t.index [:survey_id, :encounter_id], unique: true
      t.index :user_id
      t.index :parent_survey_encounter_id
    end
  end
end
