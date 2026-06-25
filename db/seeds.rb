# Seeds are intentionally deterministic and idempotent.
# Running `bin/rails db:seed` multiple times should not create duplicates.

SEED_VERSION = "v1.0.0".freeze
SEED_BASE_TIME = Time.zone.parse("2026-01-15 12:00:00 UTC").freeze

puts "== Hrefs seed #{SEED_VERSION} =="

def upsert_by!(model, finder_attrs, assign_attrs = {})
  record = model.find_or_initialize_by(finder_attrs)
  record.assign_attributes(assign_attrs)
  record.save! if record.new_record? || record.changed?
  record
end

puts "Seeding user..."
admin = User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

puts "Seeding campaigns..."
campaign_rows = [
  {
    name: "Q2 Product Launch",
    source: "email",
    medium: "newsletter",
    notes: "Primary launch campaign for existing subscribers"
  },
  {
    name: "Social Push",
    source: "social",
    medium: "twitter",
    notes: "Organic social distribution across launch week"
  },
  {
    name: "Paid Search",
    source: "google",
    medium: "cpc",
    notes: "High intent traffic from paid keywords"
  },
  {
    name: "Partner Referrals",
    source: "partner",
    medium: "affiliate",
    notes: "External partner referral links"
  },
  {
    name: "Content Engine",
    source: "organic",
    medium: "blog",
    notes: "Evergreen links from long-form content"
  }
]

campaigns_by_name = campaign_rows.each_with_object({}) do |row, memo|
  campaign = upsert_by!(Campaign, { name: row[:name] }, row.except(:name))
  memo[campaign.name] = campaign
end

puts "Seeding links..."
link_rows = [
  {
    name: "Homepage",
    slug: "home",
    destination_url: "https://example.com",
    active: true,
    expires_at: nil,
    campaign_names: [ "Q2 Product Launch", "Content Engine" ]
  },
  {
    name: "Pricing",
    slug: "pricing",
    destination_url: "https://example.com/pricing",
    active: true,
    expires_at: nil,
    campaign_names: [ "Paid Search" ]
  },
  {
    name: "Documentation",
    slug: "docs",
    destination_url: "https://docs.example.com",
    active: true,
    expires_at: 1.year.from_now,
    campaign_names: [ "Content Engine" ]
  },
  {
    name: "Twitter Promo",
    slug: "social-launch",
    destination_url: "https://example.com/promo?utm_source=twitter&utm_medium=social",
    active: true,
    expires_at: nil,
    campaign_names: [ "Social Push" ]
  },
  {
    name: "Partner LP",
    slug: "partner-landing",
    destination_url: "https://example.com/partners/landing",
    active: true,
    expires_at: nil,
    campaign_names: [ "Partner Referrals" ]
  },
  {
    name: "Retargeting LP",
    slug: "retarget",
    destination_url: "https://example.com/lp/retarget",
    active: true,
    expires_at: nil,
    campaign_names: [ "Paid Search" ]
  },
  {
    name: "Legacy Promo",
    slug: "legacy-promo",
    destination_url: "https://example.com/promo/legacy",
    active: false,
    expires_at: 2.months.ago,
    campaign_names: [ "Q2 Product Launch" ]
  },
  {
    name: "Status Page",
    slug: "status",
    destination_url: "https://status.example.com",
    active: true,
    expires_at: nil,
    campaign_names: []
  },
  {
    name: "Android App",
    slug: "android-app",
    destination_url: "https://play.google.com/store/apps/details?id=com.example.app",
    active: true,
    expires_at: nil,
    campaign_names: [ "Social Push", "Paid Search" ]
  },
  {
    name: "iOS App",
    slug: "ios-app",
    destination_url: "https://apps.apple.com/app/example/id123456789",
    active: true,
    expires_at: nil,
    campaign_names: [ "Social Push", "Paid Search" ]
  }
]

links_by_slug = link_rows.each_with_object({}) do |row, memo|
  link = upsert_by!(
    Link,
    { slug: row[:slug] },
    {
      name: row[:name],
      destination_url: row[:destination_url],
      active: row[:active],
      expires_at: row[:expires_at]
    }
  )
  memo[link.slug] = link
end

puts "Seeding link-campaign associations..."
link_rows.each do |row|
  link = links_by_slug.fetch(row[:slug])

  row[:campaign_names].each do |campaign_name|
    campaign = campaigns_by_name.fetch(campaign_name)
    LinkCampaign.find_or_create_by!(link: link, campaign: campaign)
  end
end

puts "Seeding sessions..."
Session.find_or_create_by!(
  user: admin,
  ip_address: "127.0.0.1",
  user_agent: "Seed Browser/1.0"
)

puts "Seeding visits..."
human_agents = [
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15",
  "Mozilla/5.0 (X11; Linux x86_64; rv:127.0) Gecko/20100101 Firefox/127.0",
  "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.6422.141 Mobile Safari/537.36",
  "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
]

bot_agents = [
  "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
  "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)",
  "curl/8.7.1",
  "python-requests/2.32.3"
]

referers = [
  "https://www.google.com/search?q=example+product",
  "https://news.ycombinator.com",
  "https://www.reddit.com/r/ruby",
  "https://www.linkedin.com",
  nil
]

ips = [
  "203.0.113.10",
  "203.0.113.11",
  "198.51.100.20",
  "198.51.100.21",
  "192.0.2.30",
  "192.0.2.31"
]

visit_targets_by_slug = {
  "home" => 54,
  "pricing" => 42,
  "docs" => 28,
  "social-launch" => 36,
  "partner-landing" => 22,
  "retarget" => 34,
  "status" => 18,
  "android-app" => 26,
  "ios-app" => 24,
  "legacy-promo" => 8
}

visit_targets_by_slug.each do |slug, count|
  link = links_by_slug.fetch(slug)

  count.times do |i|
    ua_pool = (i % 7).zero? ? bot_agents : human_agents
    user_agent = ua_pool[i % ua_pool.length]
    visited_at = SEED_BASE_TIME - (i * 3 + slug.length).hours
    referer = referers[(i + slug.length) % referers.length]
    ip_address = ips[(i + slug.length) % ips.length]

    Visit.find_or_create_by!(
      link: link,
      ip_address: ip_address,
      user_agent: user_agent,
      referer: referer,
      visited_at: visited_at
    )
  end

  # Keep summary analytics consistent with actual captured visits.
  link.update!(clicks_count: link.visits.count)
end

puts "\nSeed summary"
puts "  Users: #{User.count}"
puts "  Sessions: #{Session.count}"
puts "  Campaigns: #{Campaign.count}"
puts "  Links: #{Link.count}"
puts "  LinkCampaigns: #{LinkCampaign.count}"
puts "  Visits: #{Visit.count}"
puts "  Visits (last 24h): #{Visit.where(visited_at: 24.hours.ago..).count}"
puts "  Visits (last 7d): #{Visit.where(visited_at: 7.days.ago..).count}"
puts "  Top links: #{Link.top_by_clicks(5).map { |l| "#{l.slug}=#{l.clicks_count}" }.join(", ")}"
puts "== Seed complete =="
