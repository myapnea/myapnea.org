json.answer_sessions @answer_sessions do |answer_session|
  json.id answer_session.id
  json.survey_id answer_session.survey_id
  json.encounter answer_session.encounter
  json.completed answer_session.completed
  json.locked answer_session.locked
end
