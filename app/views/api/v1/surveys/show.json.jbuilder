json.name @survey.name_en
json.description "Example survey description"
json.questions @survey.questions.current.each do |question|
  json.id question.id
  json.text question.text_en
  json.display_type question.display_type
  json.slug question.slug
  json.answer_templates question.answer_templates.current.each do |at|
    json.id at.id
    json.name at.name
    json.text at.text
    json.display_after_question nil
    json.display_after_answer at.target_answer_option
    json.data_type at.data_type
    json.allow_multiple at.allow_multiple
    json.answer_options at.answer_options.each do |ao|
      json.id ao.id
      json.text ao.text
      json.value ao.value
    end
  end
end

