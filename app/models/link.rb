class Link < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_many :link_campaigns, dependent: :destroy
  has_many :campaigns, through: :link_campaigns

  before_validation :normalize_slug

  validates :name, presence: true
  validates :slug, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: /\A[a-z0-9][a-z0-9_-]*\z/, message: "must be URL-safe (lowercase letters, numbers, - and _)" }
  validates :destination_url, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  validates :clicks_count, numericality: { greater_than_or_equal_to: 0 }
  validate :destination_url_must_be_http_or_https

  scope :search, ->(query) {
    return all if query.blank?

    where("name ILIKE :q OR slug ILIKE :q", q: "%#{query}%")
  }
  scope :top_by_clicks, ->(limit_count = 5) { order(clicks_count: :desc).limit(limit_count) }

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def available_for_redirect?
    active? && !expired?
  end

  private
    def normalize_slug
      self.slug = slug.to_s.strip.downcase
    end

    def destination_url_must_be_http_or_https
      return if destination_url.blank?

      uri = URI.parse(destination_url)
      return if uri.is_a?(URI::HTTP) && uri.host.present?

      errors.add(:destination_url, "must be a valid HTTP or HTTPS URL")
    rescue URI::InvalidURIError
      errors.add(:destination_url, "must be a valid HTTP or HTTPS URL")
    end
end
