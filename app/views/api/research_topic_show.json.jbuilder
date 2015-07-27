if @research_topic.present?
  json.extract! @research_topic, :id, :text, :description
  json.posts @research_topic.topic.posts do |post|
    json.id post.id
    json.description post.description
    json.user User.find(post.user_id).forum_name
  end
else
  json.success false
end
