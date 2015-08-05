json.answer_sessions @answer_sessions do |answer_session|
  json.id answer_session.id
  json.survey_id answer_session.survey_id
  json.survey_name answer_session.survey.name
  json.encounter answer_session.encounter
  json.locked answer_session.locked
end
