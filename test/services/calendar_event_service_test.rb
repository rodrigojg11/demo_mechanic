require "test_helper"

class CalendarEventServiceTest < ActiveSupport::TestCase
  test "syncs an internal calendar event with ICS payload" do
    appointment = create_appointment

    event = CalendarEventService.new(appointment).sync!

    assert_equal "internal", event.provider
    assert_match "BEGIN:VCALENDAR", event.ics_payload
    assert_match "METHOD:REQUEST", event.ics_payload
    assert_match appointment.service.name, event.ics_payload
  end

  test "cancels existing calendar event" do
    appointment = create_appointment
    CalendarEventService.new(appointment).sync!

    CalendarEventService.new(appointment).cancel!

    event = appointment.calendar_event.reload
    assert event.cancelled?
    assert_match "METHOD:CANCEL", event.ics_payload
  end
end
