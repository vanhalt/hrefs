require "test_helper"

class VisitTest < ActiveSupport::TestCase
  test "sets visited_at and parsed fields before validation" do
    visit = Visit.new(link: links(:one), ip_address: "127.0.0.1", user_agent: "Mozilla/5.0")

    assert visit.valid?
    assert_not_nil visit.visited_at
    assert_not visit.browser.blank?
    assert_not visit.os.blank?
    assert_not visit.device_type.blank?
  end

  test "detects bot user agents" do
    visit = Visit.new(link: links(:one), ip_address: "127.0.0.1", user_agent: "Googlebot/2.1")

    visit.valid?

    assert_equal true, visit.bot
  end
end
