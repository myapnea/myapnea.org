class UpdateSurveyReportViews2 < ActiveRecord::Migration[4.2]
  def up
    timestamp = '20150204194444'
    execute "drop view survey_answer_frequencies"
    execute "drop view report_answer_totals"
    execute "drop view report_answer_counts"
    execute "drop view report_answer_options"
    execute view_sql(timestamp, :report_answer_options)
    execute view_sql(timestamp, :report_answer_counts)
    execute view_sql(timestamp, :report_answer_totals)
    execute view_sql(timestamp, :survey_answer_frequencies)
  end

  def down
    timestamp = '20150129043455'
    execute view_sql(timestamp, :report_answer_options)
    execute view_sql(timestamp, :report_answer_counts)
    execute view_sql(timestamp, :report_answer_totals)
    execute view_sql(timestamp, :survey_answer_frequencies)
  end
end
