class AppointmentExpirationJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    appointment.expire_unconfirmed! if appointment.status.in?(%w[requested scheduled])
  end
end
