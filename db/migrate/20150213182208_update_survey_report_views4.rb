class UpdateSurveyReportViews4 < ActiveRecord::Migration[4.2]
  def up
    timestamp = '20150213082208'

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
    timestamp = '20150212053201'
    execute "drop view survey_answer_frequencies"
    execute "drop view report_answer_totals"
    execute "drop view report_answer_counts"
    execute "drop view report_answer_options"
    execute view_sql(timestamp, :report_answer_options)
    execute view_sql(timestamp, :report_answer_counts)
    execute view_sql(timestamp, :report_answer_totals)
    execute view_sql(timestamp, :survey_answer_frequencies)
  end
end
