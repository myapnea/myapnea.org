json.topics @topics do |topic|
  json.id topic.id
  json.forum topic.forum.name
  json.name topic.name
  json.slug topic.slug
  json.user topic.user.forum_name
  json.user_photo_url topic.user.api_photo_url
  json.pinned topic.pinned
  json.locked topic.locked
end
