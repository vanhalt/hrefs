require "test_helper"

class RedirectsControllerTest < ActionDispatch::IntegrationTest
  test "redirects active link and records visit" do
    link = links(:one)
    link.update!(active: true, expires_at: nil, clicks_count: 0)

    assert_difference("Visit.count", 1) do
      get short_path(link.slug), headers: { "User-Agent" => "Mozilla/5.0", "Referer" => "https://example.net" }
    end

    assert_redirected_to link.destination_url
    assert_equal 1, link.reload.clicks_count
    visit = Visit.order(:id).last
    assert_equal link.id, visit.link_id
    assert_equal "https://example.net", visit.referer
  end

  test "returns 404 for missing slug" do
    get short_path("missing-link")

    assert_response :not_found
  end

  test "returns forbidden for inactive link" do
    link = links(:one)
    link.update!(active: false)

    get short_path(link.slug)

    assert_response :forbidden
  end

  test "returns gone for expired link" do
    link = links(:one)
    link.update!(active: true, expires_at: 1.day.ago)

    get short_path(link.slug)

    assert_response :gone
  end
end
