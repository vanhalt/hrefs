class Visit < ApplicationRecord
  belongs_to :link

  BOT_PATTERN = /bot|crawler|spider|preview|headless|curl|wget|python-requests|monitoring/i

  before_validation :set_defaults

  validates :ip_address, presence: true
  validates :user_agent, presence: true
  validates :visited_at, presence: true
  validates :bot, inclusion: { in: [ true, false ] }

  scope :recent_first, -> { order(visited_at: :desc, id: :desc) }
  scope :for_link, ->(link_id) {
    return all if link_id.blank?

    where(link_id: link_id)
  }
  scope :from_date, ->(date) {
    return all if date.blank?

    begin
      parsed = Date.iso8601(date)
      where(visited_at: parsed.beginning_of_day..)
    rescue ArgumentError
      all
    end
  }
  scope :to_date, ->(date) {
    return all if date.blank?

    begin
      parsed = Date.iso8601(date)
      where(visited_at: ..parsed.end_of_day)
    rescue ArgumentError
      all
    end
  }
  scope :for_bot_flag, ->(flag) {
    return all if flag.blank?

    where(bot: ActiveModel::Type::Boolean.new.cast(flag))
  }

  def enrich_from_request!(request)
    self.ip_address = request.remote_ip
    self.user_agent = request.user_agent.to_s.presence || "Unknown"
    self.referer = request.referer
    self.visited_at ||= Time.current

    parse_user_agent_fields
  end

  private
    def set_defaults
      self.visited_at ||= Time.current
      self.bot = false if bot.nil?
      parse_user_agent_fields if user_agent.present?
    end

    def parse_user_agent_fields
      ua_text = user_agent.to_s

      self.browser ||= detect_browser(ua_text)
      self.os ||= detect_os(ua_text)
      self.device_type ||= detect_device_type(ua_text)
      self.bot = BOT_PATTERN.match?(user_agent.to_s) if bot.nil? || bot == false
    rescue StandardError
      self.browser ||= "Unknown"
      self.os ||= "Unknown"
      self.device_type ||= "Unknown"
      self.bot = BOT_PATTERN.match?(user_agent.to_s)
    end

    def detect_browser(ua_text)
      return "Edge" if ua_text.match?(/edg\//i)
      return "Chrome" if ua_text.match?(/chrome\//i)
      return "Firefox" if ua_text.match?(/firefox\//i)
      return "Safari" if ua_text.match?(/safari\//i) && !ua_text.match?(/chrome\//i)

      "Unknown"
    end

    def detect_os(ua_text)
      return "Windows" if ua_text.match?(/windows/i)
      return "macOS" if ua_text.match?(/mac os|macintosh/i)
      return "Linux" if ua_text.match?(/linux/i)
      return "Android" if ua_text.match?(/android/i)
      return "iOS" if ua_text.match?(/iphone|ipad|ios/i)

      "Unknown"
    end

    def detect_device_type(ua_text)
      return "Tablet" if ua_text.match?(/ipad|tablet/i)
      return "Mobile" if ua_text.match?(/mobile|iphone|android/i)

      "Desktop"
    end
end
