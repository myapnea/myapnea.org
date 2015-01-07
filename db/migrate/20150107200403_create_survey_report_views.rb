class CreateSurveyReportViews < ActiveRecord::Migration
  def up
    timestamp = '20140107145455'
    create_view :report_answer_options, view_sql(timestamp, :report_answer_options)
    create_view :report_answer_counts, view_sql(timestamp, :report_answer_counts)
    create_view :report_answer_totals, view_sql(timestamp, :report_answer_totals)
    create_view :survey_answer_frequencies, view_sql(timestamp, :report_answer_frequencies)

  end

  def down
    drop_view :survey_answer_frequencies
    drop_view :report_answer_options
    drop_view :report_answer_counts
    drop_view :report_answer_totals
  end
end
