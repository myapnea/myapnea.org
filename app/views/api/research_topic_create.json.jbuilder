if @new_research_topic.present?
  json.extract! @new_research_topic, :id, :text, :description, :topic_id
else
  json.success false
end
