json.research_topics @research_topics do |research_topic|
  json.id research_topic.id
  json.title research_topic.text
  json.description research_topic.description
  json.endorsement research_topic.endorsement
  json.votes research_topic.votes.current.count
  json.user User.find(research_topic.user_id).forum_name
end
