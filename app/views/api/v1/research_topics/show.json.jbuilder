json.partial! 'api/v1/research_topics/research_topic', research_topic: @research_topic
json.posts @research_topic.topic.posts do |post|
  json.id post.id
  json.description post.description
  json.user post.user.forum_name
  json.user_photo_url post.user.api_photo_url
end

