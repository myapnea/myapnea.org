if @post.present?
  json.partial! 'api/posts/post', post: @post
else
  json.success false
end
