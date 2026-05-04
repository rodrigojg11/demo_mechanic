class Notification < ApplicationRecord
  CHANNELS = %w[sms email push].freeze
  STATUSES = %w[pending sent failed cancelled].freeze

  belongs_to :appointment

  validates :channel, inclusion: { in: CHANNELS }
  validates :status, inclusion: { in: STATUSES }
  validates :recipient, presence: true

  before_validation :set_default_status

  def pending?
    status == "pending"
  end

  def mark_sent!
    update!(status: "sent", sent_at: Time.current)
  end

  def mark_failed!(message)
    update!(status: "failed", error_message: message)
  end

  private

  def set_default_status
    self.status ||= "pending"
  end
end
