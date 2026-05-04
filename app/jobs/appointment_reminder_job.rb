class AppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    return unless appointment.status.in?(%w[requested scheduled customer_confirmed])
    return if appointment.scheduled_at <= Time.current

    AppointmentNotificationService.new(appointment).enqueue_customer_reminder
  end
end
