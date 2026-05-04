class CalendarEventService
  PROVIDER = "internal"

  def initialize(appointment)
    @appointment = appointment
  end

  def sync!
    calendar_event = appointment.calendar_event || appointment.build_calendar_event(provider: PROVIDER)
    calendar_event.assign_attributes(
      external_id: external_id,
      calendar_url: calendar_url,
      ics_payload: ics_payload,
      synced_at: Time.current,
      cancelled_at: nil
    )
    calendar_event.save!
    calendar_event
  end

  def cancel!
    return unless appointment.calendar_event

    appointment.calendar_event.update!(
      cancelled_at: Time.current,
      synced_at: Time.current,
      ics_payload: ics_payload(cancelled: true)
    )
  end

  private

  attr_reader :appointment

  def external_id
    "cruz-auto-appointment-#{appointment.id}"
  end

  def calendar_url
    Rails.application.routes.url_helpers.appointment_calendar_url(
      appointment,
      host: "cruzauto.local",
      format: :ics
    )
  end

  def ics_payload(cancelled: false)
    [
      "BEGIN:VCALENDAR",
      "VERSION:2.0",
      "PRODID:-//Cruz Auto//Appointments//EN",
      "CALSCALE:GREGORIAN",
      "METHOD:#{cancelled ? "CANCEL" : "REQUEST"}",
      "BEGIN:VEVENT",
      "UID:#{external_id}@cruzauto.local",
      "DTSTAMP:#{timestamp(Time.current)}",
      "DTSTART:#{timestamp(appointment.scheduled_at)}",
      "DTEND:#{timestamp(appointment.end_at)}",
      "SUMMARY:#{escape("Cruz Auto - #{appointment.service.name}")}",
      "DESCRIPTION:#{escape(description)}",
      "LOCATION:#{escape("632 W Davis St, Dallas, TX 75208")}",
      "STATUS:#{cancelled ? "CANCELLED" : "CONFIRMED"}",
      "END:VEVENT",
      "END:VCALENDAR"
    ].join("\r\n")
  end

  def description
    "Customer: #{appointment.customer.name}. Vehicle: #{appointment.vehicle.display_name}. Phone: #{appointment.customer.phone}."
  end

  def timestamp(time)
    time.utc.strftime("%Y%m%dT%H%M%SZ")
  end

  def escape(value)
    value.to_s.gsub("\\", "\\\\\\").gsub("\n", "\\n").gsub(",", "\\,").gsub(";", "\\;")
  end
end
