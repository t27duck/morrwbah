json.array!(@entries) do |entry|
  json.extract! entry, :feed_id, :user_id, :title, :url, :author, :summary, :content, :published, :read, :starred
  json.url entry_url(entry, format: :json)
end