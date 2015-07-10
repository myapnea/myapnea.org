if @topic.present?
  json.extract! @topic, :id, :name, :description, :user_id, :forum_id
else
  json.success false
end
