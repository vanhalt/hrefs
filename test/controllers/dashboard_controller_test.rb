require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "should get show" do
    get root_url

    assert_response :success
    assert_select "h1", text: "Dashboard"
    assert_select "h2", text: "Traffic over time"
    assert_select "h2", text: "Top links by clicks"
    assert_select "h2", text: "Audience mix"
    assert_select "h2", text: "Recent visits"
  end
end