if @new_research_topic.present?
  json.partial! 'api/research_topics/research_topic', research_topic: @new_research_topic
else
  json.success false
end
