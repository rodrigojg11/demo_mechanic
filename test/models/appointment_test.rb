require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  test "requires future shop time" do
    appointment = build_appointment(scheduled_at: 1.hour.ago)

    assert_not appointment.valid?
    assert_includes appointment.errors[:scheduled_at], "must be in the future"
  end

  test "blocks Sundays" do
    sunday = next_shop_time
    sunday += 1.day until sunday.sunday?
    appointment = build_appointment(scheduled_at: sunday.change(hour: 10))

    assert_not appointment.valid?
    assert_includes appointment.errors[:scheduled_at], "is not available on Sundays"
  end

  test "prevents double booking with service buffer" do
    service = create_service(duration_minutes: 60, buffer_minutes: 30)
    scheduled_at = next_shop_time
    create_appointment(service: service, scheduled_at: scheduled_at)
    overlapping = build_appointment(service: service, scheduled_at: scheduled_at + 75.minutes)

    assert_not overlapping.valid?
    assert_includes overlapping.errors[:scheduled_at], "is already booked"
  end

  test "released appointments do not block availability" do
    service = create_service(duration_minutes: 60, buffer_minutes: 30)
    scheduled_at = next_shop_time
    create_appointment(service: service, scheduled_at: scheduled_at).release!
    available = build_appointment(service: service, scheduled_at: scheduled_at)

    assert available.valid?, available.errors.full_messages.to_sentence
  end

  private

  def build_appointment(service: create_service, scheduled_at: next_shop_time)
    customer = create_customer
    vehicle = create_vehicle(customer: customer)

    Appointment.new(
      customer: customer,
      vehicle: vehicle,
      service: service,
      scheduled_at: scheduled_at,
      payment_preference: "pay_after_service"
    )
  end
end
