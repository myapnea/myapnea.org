class RemoveSurveyEncountersView < ActiveRecord::Migration[4.2]
  def up
    execute "drop view survey_answer_frequencies"
    execute "drop view survey_encounters"
  end

  def down
    timestamp = '20150327171203'
    execute view_sql(timestamp, :survey_encounters)
    execute view_sql(timestamp, :survey_answer_frequencies)
  end
end
