class LinkCampaignsController < ApplicationController
  before_action :set_link_campaign, only: %i[ show edit update destroy ]

  # GET /link_campaigns or /link_campaigns.json
  def index
    @link_campaigns = LinkCampaign.all
  end

  # GET /link_campaigns/1 or /link_campaigns/1.json
  def show
  end

  # GET /link_campaigns/new
  def new
    @link_campaign = LinkCampaign.new
  end

  # GET /link_campaigns/1/edit
  def edit
  end

  # POST /link_campaigns or /link_campaigns.json
  def create
    @link_campaign = LinkCampaign.new(link_campaign_params)

    respond_to do |format|
      if @link_campaign.save
        format.html { redirect_to @link_campaign, notice: "Link campaign was successfully created." }
        format.json { render :show, status: :created, location: @link_campaign }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @link_campaign.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /link_campaigns/1 or /link_campaigns/1.json
  def update
    respond_to do |format|
      if @link_campaign.update(link_campaign_params)
        format.html { redirect_to @link_campaign, notice: "Link campaign was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @link_campaign }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @link_campaign.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /link_campaigns/1 or /link_campaigns/1.json
  def destroy
    @link_campaign.destroy!

    respond_to do |format|
      format.html { redirect_to link_campaigns_path, notice: "Link campaign was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link_campaign
      @link_campaign = LinkCampaign.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def link_campaign_params
      params.expect(link_campaign: [ :link_id, :campaign_id ])
    end
end
