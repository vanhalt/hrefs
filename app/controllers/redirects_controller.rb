class RedirectsController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @link = Link.find_by(slug: params[:slug].to_s.downcase)

    return render :missing, status: :not_found unless @link
    return render :inactive, status: :forbidden unless @link.active?
    return render :expired, status: :gone if @link.expired?

    visit = @link.visits.new
    visit.enrich_from_request!(request)
    visit.save!
    @link.increment!(:clicks_count)

    redirect_to @link.destination_url, allow_other_host: true
  end
end
