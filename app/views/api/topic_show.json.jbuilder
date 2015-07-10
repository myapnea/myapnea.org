json.posts @posts do |post|
  json.id post.id
  json.description post.description
  json.user User.find(post.user_id).forum_name
  json.links_enabled post.links_enabled
end
