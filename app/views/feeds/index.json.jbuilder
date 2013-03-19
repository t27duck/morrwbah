json.array!(@feeds) do |feed|
  json.extract! feed, :user_id, :title, :url, :feed_url, :etag, :last_modified, :sanitize
  json.url feed_url(feed, format: :json)
end