class Campaign < ApplicationRecord
  has_many :link_campaigns, dependent: :destroy
  has_many :links, through: :link_campaigns
end
