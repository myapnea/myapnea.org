json.posts @posts do |post|
  json.id post.id
  json.description post.description
  json.user_id post.user_id
  json.links_enabled post.links_enabled
end
