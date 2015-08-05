json.votes @votes do |vote|
  json.id vote.id
  json.research_topic_id vote.research_topic_id
  json.rating vote.rating
end
