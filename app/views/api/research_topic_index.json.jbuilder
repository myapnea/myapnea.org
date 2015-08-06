json.research_topics @research_topics do |research_topic|
  json.partial! 'api/research_topics/research_topic', research_topic: research_topic
end
