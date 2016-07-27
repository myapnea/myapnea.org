class CreateSurveyReportViews < ActiveRecord::Migration[4.2]
  def up
    timestamp = '20140107145455'
    execute view_sql(timestamp, :report_answer_options)
    execute view_sql(timestamp, :report_answer_counts)
    execute view_sql(timestamp, :report_answer_totals)
    execute view_sql(timestamp, :survey_answer_frequencies)

  end

  def down
    execute "drop view survey_answer_frequencies"
    execute "drop view report_answer_options"
    execute "drop view report_answer_counts"
    execute "drop view report_answer_totals"
  end
end
