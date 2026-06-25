require "test_helper"

class VisitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visit = visits(:one)
    sign_in_as(users(:one))
  end

  test "should get index" do
    get visits_url
    assert_response :success
  end

  test "should show visit" do
    get visit_url(@visit)
    assert_response :success
  end
end
