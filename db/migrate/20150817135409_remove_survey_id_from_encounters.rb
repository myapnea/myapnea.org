class RemoveSurveyIdFromEncounters < ActiveRecord::Migration[4.2]
  def up
    remove_index :encounters, [:survey_id, :deleted]
    remove_column :encounters, :survey_id
    add_index :encounters, :deleted
  end

  def down
    remove_index :encounters, :deleted
    add_column :encounters, :survey_id, :integer
    add_index :encounters, [:survey_id, :deleted]
  end
end
