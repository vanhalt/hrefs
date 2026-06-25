class DashboardController < ApplicationController
  def show
    @total_links = Link.count
    @total_visits = Visit.count
    @visits_last_24h = Visit.where(visited_at: 24.hours.ago..).count
    @visits_last_7d = Visit.where(visited_at: 7.days.ago..).count
    @top_links = Link.top_by_clicks(5)
    @recent_visits = Visit.includes(:link).recent_first.limit(10)
  end
end
