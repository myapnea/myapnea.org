if @post.present?
  json.extract! @post, :id, :description, :topic_id
else
  json.success false
end
