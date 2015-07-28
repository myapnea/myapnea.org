json.array!(@children) do |child|
  json.extract! child, :id, :user_id, :first_name, :age, :accepted_consent_at, :deleted
  json.url child_url(child, format: :json)
end
