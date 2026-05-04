class AppointmentNotificationService
  MECHANIC_PHONE = "12145550199"
  MECHANIC_EMAIL = "hello@cruzauto.shop"
  MECHANIC_PUSH_TARGET = "mechanic-device"

  def initialize(appointment)
    @appointment = appointment
  end

  def enqueue_initial_notifications
    ensure_token

    notify_mechanic
    notify_customer_confirmation
    schedule_customer_reminder
    schedule_confirmation_expiration
  end

  def enqueue_customer_reminder
    confirmation_url = response_url("confirm")
    cancellation_url = response_url("cancel")

    create_and_enqueue!(
      channel: "sms",
      recipient: appointment.customer.phone,
      subject: "Appointment reminder",
      body: "Reminder: your Cruz Auto appointment is #{appointment_time}. Confirm: #{confirmation_url} Cancel: #{cancellation_url}"
    )

    create_and_enqueue!(
      channel: "email",
      recipient: appointment.customer.email,
      subject: "Confirm your Cruz Auto appointment",
      body: "Your appointment is #{appointment_time}. Confirm here: #{confirmation_url}. Cancel here: #{cancellation_url}."
    )
  end

  private

  attr_reader :appointment

  def notify_mechanic
    body = "New appointment request: #{appointment.customer.name}, #{appointment.service.name}, #{appointment_time}, #{appointment.vehicle.display_name}."
    body = "#{body} Calendar: #{appointment.calendar_event&.calendar_url}"
    body = "#{body} #{payment_summary}"

    create_and_enqueue!(channel: "sms", recipient: MECHANIC_PHONE, subject: "New appointment request", body: body)
    create_and_enqueue!(channel: "email", recipient: MECHANIC_EMAIL, subject: "New appointment request", body: body)
    create_and_enqueue!(channel: "push", recipient: MECHANIC_PUSH_TARGET, subject: "New appointment request", body: body)
  end

  def notify_customer_confirmation
    confirmation_url = response_url("confirm")
    cancellation_url = response_url("cancel")
    reschedule_url = response_url("reschedule")

    body = "We received your Cruz Auto appointment request for #{appointment_time}. Confirm: #{confirmation_url}. Cancel: #{cancellation_url}. Reschedule: #{reschedule_url}. Calendar invite: #{appointment.calendar_event&.calendar_url}."
    body = "#{body} #{payment_summary}"

    create_and_enqueue!(channel: "sms", recipient: appointment.customer.phone, subject: "Appointment request received", body: body)
    create_and_enqueue!(channel: "email", recipient: appointment.customer.email, subject: "Cruz Auto appointment request", body: body)
  end

  def schedule_customer_reminder
    reminder_at = appointment.scheduled_at - 24.hours
    return if reminder_at <= Time.current

    AppointmentReminderJob.set(wait_until: reminder_at).perform_later(appointment)
  end

  def schedule_confirmation_expiration
    AppointmentExpirationJob.set(wait_until: appointment.scheduled_at - 12.hours).perform_later(appointment) if appointment.scheduled_at > 12.hours.from_now
  end

  def create_and_enqueue!(attributes)
    notification = appointment.notifications.create!(attributes)
    NotificationDeliveryJob.perform_later(notification)
    notification
  end

  def ensure_token
    appointment.appointment_confirmation_token || appointment.create_appointment_confirmation_token!
  end

  def token
    appointment.appointment_confirmation_token.signed_response_id
  end

  def response_url(action)
    Rails.application.routes.url_helpers.public_send(
      "#{action}_appointment_response_url",
      token: token,
      host: "cruzauto.local"
    )
  end

  def appointment_time
    appointment.scheduled_at.strftime("%a %b %-d at %-I:%M %p")
  end

  def payment_summary
    payment = appointment.payment
    return "Payment: not prepared yet." if payment.nil?
    return "Payment: pay after service." if payment.provider == "manual"
    return "Payment link: #{payment.checkout_url}" if payment.pending? && payment.checkout_url.present?

    "Payment status: #{payment.status.humanize}."
  end
end
