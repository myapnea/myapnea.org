json.votes @votes do |vote|
  json.id vote.id
  json.user User.find(vote.user_id).forum_name
  json.research_topic_id vote.research_topic_id
  json.rating vote.rating
end
