class UpdateSurveyReportViews3 < ActiveRecord::Migration
  def up
    timestamp = '20150212053201'
    execute "drop view survey_answer_frequencies"
    execute "drop view report_answer_options"
    execute view_sql(timestamp, :report_answer_options)
    execute view_sql(timestamp, :survey_answer_frequencies)
  end

  def down
    timestamp = '20150204194444'
    execute view_sql(timestamp, :report_answer_options)
    execute view_sql(timestamp, :survey_answer_frequencies)
  end
end
