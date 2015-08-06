if @topic.present?
  json.partial! 'api/topics/topic', topic: @topic
else
  json.success false
end
