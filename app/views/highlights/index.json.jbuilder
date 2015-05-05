json.array!(@highlights) do |highlight|
  json.extract! highlight, :id, :title, :description, :photo, :display_date
  json.url highlight_url(highlight, format: :json)
end
