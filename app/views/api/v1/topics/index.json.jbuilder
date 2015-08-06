json.topics @topics.each do |topic|
  json.partial! 'api/v1/topics/topic', topic: topic
end
