class VisitsController < ApplicationController
  before_action :set_visit, only: %i[ show ]

  # GET /visits or /visits.json
  def index
    @filters = {
      link_id: params[:link_id],
      start_date: params[:start_date],
      end_date: params[:end_date],
      bot: params[:bot]
    }

    visits = Visit.includes(:link)
                  .for_link(@filters[:link_id])
                  .from_date(@filters[:start_date])
                  .to_date(@filters[:end_date])
                  .for_bot_flag(@filters[:bot])
                  .recent_first

    @pagy, @visits = pagy(visits, limit: 25)
    @links_for_filter = Link.order(:name)
  end

  # GET /visits/1 or /visits/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params.expect(:id))
    end
end
