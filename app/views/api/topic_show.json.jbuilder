json.posts @posts do |post|
  json.id post.id
  json.description post.description
  json.created_at post.created_at.strftime("%Y-%m-%d")
  json.user post.user.forum_name
  json.user_photo_url post.user.api_photo_url
  json.links_enabled post.links_enabled
end
