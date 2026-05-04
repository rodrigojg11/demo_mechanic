require "test_helper"

class ShopAvailabilityTest < ActiveSupport::TestCase
  test "does not expose Sundays" do
    sunday = next_shop_time.to_date
    sunday += 1.day until sunday.sunday?

    assert_empty ShopAvailability.new(date: sunday, service: create_service).slots
  end

  test "marks booked slots unavailable" do
    service = create_service(duration_minutes: 60, buffer_minutes: 15)
    scheduled_at = next_shop_time
    create_appointment(service: service, scheduled_at: scheduled_at)

    slot = ShopAvailability.new(date: scheduled_at.to_date, service: service).slots.find { |item| item[:label] == "10:00 AM" }

    assert_equal false, slot[:available]
  end
end
