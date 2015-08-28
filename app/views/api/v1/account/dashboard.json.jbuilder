json.survey_completion current_user.completed_answer_sessions.count * 100.0 / (current_user.completed_answer_sessions.count + current_user.incomplete_answer_sessions.count)
json.community_count User.current.count
json.provider_count User.current.where(provider: true).count
json.recent_news_title Highlight.last.title
json.recent_news_link Highlight.last.link

# Demographics
## Sex
question = @about_me_survey.questions.find_by_slug('sex')
answer_template = question.first_radio_or_checkbox_answer_template if question
answer_option_counts = TemporaryReport.answer_option_counts(@survey, question, answer_template, encounter: @encounter, range: 1..2)
report_item = ReportItem.new(answer_option_counts, answer_template, 1)
json.male_percent report_item.only_percent
report_item = ReportItem.new(answer_option_counts, answer_template, 2)
json.female_percent report_item.only_percent

## Diagnoses
json.diagnosed_percent User.current.where(adult_diagnosed: true).count * 100.0 / User.current.count
json.at_risk_percent User.current.where(adult_at_risk: true).count * 100.0 / User.current.count
