json.topics @topics do |topic|
  json.id topic.id
  json.forum Forum.find(topic.forum_id).name
  json.name topic.name
  json.slug topic.slug
  json.user_id topic.user_id
  json.pinned topic.pinned
  json.locked topic.locked
end
