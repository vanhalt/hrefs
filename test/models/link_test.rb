require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "slug is normalized to lowercase" do
    link = Link.new(
      name: "Normalized",
      slug: "My-Slug",
      destination_url: "https://example.com",
      active: true,
      clicks_count: 0
    )

    assert link.valid?
    assert_equal "my-slug", link.slug
  end

  test "destination_url must be http or https" do
    link = links(:one)
    link.destination_url = "ftp://example.com"

    assert_not link.valid?
    assert_includes link.errors[:destination_url], "must be a valid HTTP or HTTPS URL"
  end

  test "slug must be unique" do
    duplicate = Link.new(
      name: "Duplicate",
      slug: links(:one).slug,
      destination_url: "https://example.com/duplicate",
      active: true,
      clicks_count: 0
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:slug], "has already been taken"
  end
end
