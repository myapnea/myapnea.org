if @post.present?
  json.extract! @post, :id, :description, :user_id, :topic_id
else
  json.success false
end
