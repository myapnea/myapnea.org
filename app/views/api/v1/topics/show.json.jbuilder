json.partial! 'api/v1/topics/topic', topic: @topic
json.posts @topic.posts.each do |post|
  json.partial! 'api/v1/posts/post', post: post
end
