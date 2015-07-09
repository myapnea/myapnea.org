if @new_research_topic.present?
  json.extract! @new_research_topic, :id, :text, :description, :user_id, :topic_id
else
  json.success false
end
