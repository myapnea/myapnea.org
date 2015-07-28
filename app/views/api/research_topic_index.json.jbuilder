json.research_topics @research_topics do |research_topic|
  json.id research_topic.id
  json.title research_topic.text
  json.description research_topic.description
  json.endorsement research_topic.endorsement
  json.votes research_topic.votes.current.count
  json.comments research_topic.topic.posts.current.count
  json.user research_topic.user.forum_name
  json.user_photo_url research_topic.user.api_photo_url
end
