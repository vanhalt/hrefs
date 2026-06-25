json.extract! campaign, :id, :name, :source, :medium, :notes, :created_at, :updated_at
json.url campaign_url(campaign, format: :json)
