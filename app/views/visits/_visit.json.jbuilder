json.extract! visit, :id, :link_id, :ip_address, :user_agent, :referer, :country, :city, :device_type, :browser, :os, :bot, :visited_at, :created_at, :updated_at
json.url visit_url(visit, format: :json)
