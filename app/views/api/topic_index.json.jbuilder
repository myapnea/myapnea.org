json.topics @topics do |topic|
  json.partial! 'api/topics/topic', topic: topic
end
