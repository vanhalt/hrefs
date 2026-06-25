class DashboardController < ApplicationController
  def show
    @total_links = Link.count
    @total_visits = Visit.count
    @visits_last_24h = Visit.where(visited_at: 24.hours.ago..).count
    @visits_last_7d = Visit.where(visited_at: 7.days.ago..).count
    @visits_by_day = Visit.where(visited_at: 30.days.ago..).group(Arel.sql("DATE(visited_at)")).order(Arel.sql("DATE(visited_at)")).count
    @top_links = Link.top_by_clicks(5)
    @top_links_by_clicks = @top_links.map { |link| ["#{link.name} (/#{link.slug})", link.clicks_count] }.to_h
    @visits_by_browser = normalized_visit_counts(:browser)
    @visits_by_device_type = normalized_visit_counts(:device_type)
    @visits_by_bot_status = Visit.group(:bot).count.transform_keys { |bot| bot ? "Bot" : "Human" }
    @recent_visits = Visit.includes(:link).recent_first.limit(10)
  end

  private
    def normalized_visit_counts(column_name)
      Visit.group(column_name).count.compact_blank.sort_by { |_label, count| -count }.to_h
    end
end
