class CreateSurveyEncounters < ActiveRecord::Migration[4.2]
  def change
    create_table :survey_encounters do |t|
      t.integer :survey_id
      t.integer :user_id
      t.integer :encounter_id
      t.integer :position, null: false, default: 0

      t.timestamps null: false
    end

    add_index :survey_encounters, [:survey_id, :encounter_id], unique: true
    add_index :survey_encounters, :user_id
  end
end
