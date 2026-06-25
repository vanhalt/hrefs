require "test_helper"

class LinkCampaignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @link_campaign = link_campaigns(:one)
    sign_in_as(users(:one))
  end

  test "should get index" do
    get link_campaigns_url
    assert_response :success
  end

  test "should get new" do
    get new_link_campaign_url
    assert_response :success
  end

  test "should create link_campaign" do
    assert_difference("LinkCampaign.count") do
      post link_campaigns_url, params: { link_campaign: { campaign_id: @link_campaign.campaign_id, link_id: @link_campaign.link_id } }
    end

    assert_redirected_to link_campaign_url(LinkCampaign.last)
  end

  test "should show link_campaign" do
    get link_campaign_url(@link_campaign)
    assert_response :success
  end

  test "should get edit" do
    get edit_link_campaign_url(@link_campaign)
    assert_response :success
  end

  test "should update link_campaign" do
    patch link_campaign_url(@link_campaign), params: { link_campaign: { campaign_id: @link_campaign.campaign_id, link_id: @link_campaign.link_id } }
    assert_redirected_to link_campaign_url(@link_campaign)
  end

  test "should destroy link_campaign" do
    assert_difference("LinkCampaign.count", -1) do
      delete link_campaign_url(@link_campaign)
    end

    assert_redirected_to link_campaigns_url
  end
end
