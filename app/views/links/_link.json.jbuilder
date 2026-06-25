json.extract! link, :id, :name, :slug, :destination_url, :active, :expires_at, :clicks_count, :created_at, :updated_at
json.url link_url(link, format: :json)
