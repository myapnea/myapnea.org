json.name @survey.name_en
json.description "Example survey description"
json.questions @survey.questions.current.each do |question|
  json.id question.id
  json.text question.text_en
  json.display_type question.display_type
  json.slug question.slug
  json.answer_templates question.answer_templates.current.each do |at|
    json.id at.id
    json.name at.name.present? ? at.name : ""
    json.text at.text.present? ? at.text : ""
    next_at = AnswerTemplate.where(parent_answer_template_id: at.id)
    json.display_after_question next_at.present? ? next_at.pluck(:id) : nil
    json.display_after_answer next_at.present? ? next_at.collect{ |at| at.parent_answer_option_id} : nil
    json.data_type at.data_type
    json.allow_multiple at.allow_multiple
    json.answer_options at.answer_options.each do |ao|
      json.id ao.id
      json.text ao.text
      json.value ao.value
    end
  end
end

