if @research_topic.present?
  json.extract! @research_topic, :id, :text, :description
  json.posts @research_topic.topic.posts do |post|
    json.id post.id
    json.description post.description
    json.user post.user.forum_name
    json.user_photo_url post.user.api_photo_url
  end
else
  json.success false
end

