json.array!(@posts) do |post|
  json.extract! post, :id, :topic_id, :description, :user_id, :status, :hidden, :deleted, :last_moderated_by_id, :last_moderated_at
  json.url post_url(post, format: :json)
end
