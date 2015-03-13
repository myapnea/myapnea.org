json.nodes @survey.survey_answer_frequencies do |answer|
  json.name answer.answer_option_text
  json.id answer.answer_option_id
  json.frequency answer.frequency*100
end

json.links @survey.survey_answer_frequencies do |answer|
  json.source answer.answer_option_id
  json.target 104
end

### FORMAT
# {
#   nodes: [
#     {
#       name:
#       option:
#       id:
#       frequency:
#     },
#   ]
#   links: [
#     {
#       source: ID
#       target: ID
#     }
#   ]
# }
