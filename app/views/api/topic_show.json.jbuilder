json.partial! 'api/topics/topic', topic: @topic
json.posts @posts do |post|
  json.partial! 'api/posts/post', post: post
end
