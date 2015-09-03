json.id topic.id
json.forum topic.forum.name
json.name topic.name
json.slug topic.slug
json.user topic.user.forum_name
json.user_photo_url topic.user.api_photo_url
json.pinned topic.pinned
json.locked topic.locked
json.postCount topic.posts.current.count
json.viewCount topic.views_count
json.last_post_at topic.posts.current.present? ? topic.posts.current.last.created_at.strftime("%Y-%m-%d %I:%M %p") : topic.created_at.strftime("%Y-%m-%d %I:%M %p")
