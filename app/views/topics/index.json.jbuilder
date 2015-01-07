json.array!(@topics) do |topic|
  json.extract! topic, :id, :forum_id, :user_id, :name, :locked, :pinned, :last_post_at, :state, :views_count, :slug
  json.url topic_url(topic, format: :json)
end
