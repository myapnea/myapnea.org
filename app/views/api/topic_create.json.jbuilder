if @topic.present?
  json.extract! @topic, :id, :name, :description, :forum_id
else
  json.success false
end
