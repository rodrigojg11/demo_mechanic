class CalendarsController < ApplicationController
  def show
    appointment = Appointment.find(calendar_params.fetch(:appointment_id))
    calendar_event = appointment.calendar_event || CalendarEventService.new(appointment).sync!

    send_data calendar_event.ics_payload,
      filename: "cruz-auto-appointment-#{appointment.id}.ics",
      type: "text/calendar; charset=utf-8"
  rescue ActiveRecord::RecordNotFound, KeyError
    head :not_found
  end

  private

  def calendar_params
    params.permit(:appointment_id)
  end
end
