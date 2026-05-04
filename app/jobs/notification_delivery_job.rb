class NotificationDeliveryJob < ApplicationJob
  queue_as :default

  def perform(notification)
    return unless notification.pending?

    notification.mark_sent!
  rescue StandardError => error
    notification.mark_failed!(error.message)
    raise
  end
end
