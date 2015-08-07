json.research_topics @research_topics do |research_topic|
  json.partial! 'api/v1/research_topics/research_topic', research_topic: research_topic
end
