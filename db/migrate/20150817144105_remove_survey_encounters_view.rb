class RemoveSurveyEncountersView < ActiveRecord::Migration
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
