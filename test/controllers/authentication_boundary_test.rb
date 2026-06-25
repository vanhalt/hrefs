require "test_helper"

class AuthenticationBoundaryTest < ActionDispatch::IntegrationTest
  test "admin routes require authentication" do
    get links_path

    assert_redirected_to new_session_path
  end

  test "public slug route is accessible without authentication" do
    link = links(:one)
    link.update!(active: false)

    get short_path(link.slug)

    assert_response :forbidden
  end
end
